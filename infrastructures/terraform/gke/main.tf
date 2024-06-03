resource "google_sql_database_instance" "skripsi_auth_db" {
  name                = "skripsi-auth-db"
  region              = "asia-southeast1"
  database_version    = "POSTGRES_15"
  deletion_protection = false

  settings {
    tier              = "db-g1-small"
    availability_type = "ZONAL"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "all"
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "google_sql_database_instance" "skripsi_tenant_db" {
  name                = "skripsi-tenant-db"
  region              = "asia-southeast1"
  database_version    = "POSTGRES_15"
  deletion_protection = false

  settings {
    tier              = "db-g1-small"
    availability_type = "ZONAL"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "all"
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "google_sql_database_instance" "skripsi_products_db" {
  name                = "skripsi-products-db"
  region              = "asia-southeast1"
  database_version    = "POSTGRES_15"
  deletion_protection = false

  settings {
    tier              = "db-g1-small"
    availability_type = "ZONAL"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "all"
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "google_sql_database_instance" "skripsi_orders_db" {
  name                = "skripsi-orders-db"
  region              = "asia-southeast1"
  database_version    = "POSTGRES_15"
  deletion_protection = false

  settings {
    tier              = "db-g1-small"
    availability_type = "ZONAL"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "all"
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "google_sql_database_instance" "skripsi_wishlist_db" {
  name                = "skripsi-wishlist-db"
  region              = "asia-southeast1"
  database_version    = "POSTGRES_15"
  deletion_protection = false

  settings {
    tier              = "db-g1-small"
    availability_type = "ZONAL"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "all"
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "google_sql_user" "auth_user" {
  name            = "postgres"
  instance        = google_sql_database_instance.skripsi_auth_db.name
  password        = var.db_password
  deletion_policy = "ABANDON"
}

resource "google_sql_user" "tenant_user" {
  name            = "postgres"
  instance        = google_sql_database_instance.skripsi_tenant_db.name
  password        = var.db_password
  deletion_policy = "ABANDON"
}

resource "google_sql_user" "products_user" {
  name            = "postgres"
  instance        = google_sql_database_instance.skripsi_products_db.name
  password        = var.db_password
  deletion_policy = "ABANDON"
}

resource "google_sql_user" "orders_user" {
  name            = "postgres"
  instance        = google_sql_database_instance.skripsi_orders_db.name
  password        = var.db_password
  deletion_policy = "ABANDON"
}

resource "google_sql_user" "wishlist_user" {
  name            = "postgres"
  instance        = google_sql_database_instance.skripsi_wishlist_db.name
  password        = var.db_password
  deletion_policy = "ABANDON"
}

resource "google_container_cluster" "standard_cluster" {
  name     = "test-skripsi-cluster"
  location = "asia-southeast1"

  deletion_protection = false

  # Network settings
  network    = "default"
  subnetwork = "default"

  # Settings for controlling resource usage and access
  ip_allocation_policy {} # Required for IP address management

  description = "Standard GKE cluster managed by Terraform"

  # Node pool configuration
  node_pool {
    name       = "default-pool"
    node_count = 7 # Amount of worker nodes

    node_config {
      machine_type = "e2-standard-8"
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
      ]
    }
  }

  min_master_version = "latest"
}
