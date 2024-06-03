resource "google_compute_firewall" "k3s-firewall" {
	name = "k3s-firewall"
	network = "default"
	allow {
		protocol = "tcp"
		ports = ["6443"]
	}
    source_ranges = ["0.0.0.0/0"]
	target_tags = ["k3s"]
}

resource "google_compute_firewall" "k3s-node-port" {
	name = "k3s-node-port"
	network = "default"
	allow {
		protocol = "tcp"
		ports = ["30000-32767"]
	}
    source_ranges = ["0.0.0.0/0"]
	target_tags = ["k3s"]
}

resource "google_compute_firewall" "k3s-ssh" {
	name = "k3s-ssh"
	network = "default"
	allow {
		protocol = "tcp"
		ports = ["22"]
	}
    source_ranges = ["0.0.0.0/0"]
	target_tags = ["k3s"]
}

resource "google_compute_instance" "k3s_master_instance" {
  name         = "k3s-master"
  zone         = "asia-southeast1-a"
  machine_type = "e2-standard-8"
  tags         = ["k3s", "k3s-master"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  provisioner "local-exec" {
    command = <<EOT
            sleep 30 && \
            k3sup install \
            --ip ${self.network_interface[0].access_config[0].nat_ip} \
            --context k3s \
            --ssh-key ~/.ssh/id_rsa \
            --user vincent_suryakim
        EOT
  }

  metadata = {
    ssh-keys = "vincent_suryakim:${file("~/.ssh/id_rsa.pub")}"
  }

  depends_on = [
    google_compute_firewall.k3s-firewall,
    google_compute_firewall.k3s-ssh,
  ]
}

resource "google_compute_instance" "k3s_worker_instance" {
  count        = 7
  name         = "k3s-worker-${count.index}"
  machine_type = "e2-standard-8"
  zone         = "asia-southeast1-a"
  tags         = ["k3s", "k3s-worker"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  provisioner "local-exec" {
    command = <<EOT
            sleep 30 && \
            k3sup join \
            --ip ${self.network_interface[0].access_config[0].nat_ip} \
            --server-ip ${google_compute_instance.k3s_master_instance.network_interface[0].access_config[0].nat_ip} \
            --ssh-key ~/.ssh/id_rsa \
            --user vincent_suryakim
        EOT
  }

  metadata = {
    ssh-keys = "vincent_suryakim:${file("~/.ssh/id_rsa.pub")}"
  }

  depends_on = [
    google_compute_firewall.k3s-firewall,
    google_compute_firewall.k3s-ssh,
    google_compute_instance.k3s_master_instance
  ]
}
