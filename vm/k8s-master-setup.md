# 🚀 **How To set up Kubernetes on a virtual machine using containerd as the CRI, follow these steps:**

## **Step 1: Prepare the Virtual Machine**

- Use a VM with at least **2 CPUs, 2GB RAM**, and **20GB disk**.
- Install a compatible Linux distribution (e.g., Ubuntu 22.04 or CentOS 8).

## **Step 2: Update and Install Dependencies**

```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
```

---

## **Step 3: Install `containerd`**

### **Step 1: Update the System**

```bash
sudo apt update
```

### **Step 2: Install `containerd`**

```bash
sudo apt install -y containerd
```

### **Step 3: Verify the Installation**

```bash
containerd --version
```

You should see the version output (e.g., `containerd 1.7.x`).

---

### **Step 4: Generate `containerd` Configuration**

```bash
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
```

#### Enable systemd cgroup driver (important for Kubernetes): Edit /etc/containerd/config.toml:

```bash
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml


```

---

### **Step 5: Enable `containerd` to Start Automatically**

```bash
sudo systemctl enable containerd
sudo systemctl start containerd
```

### **Step 6: Verify `containerd` Status**

```bash
sudo systemctl status containerd
```

---

## **Step 4: Install Kubernetes Tools**

1. **Add Kubernetes repository:**

```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
```

2. **Install `kubelet`, `kubeadm`, and `kubectl`:**

```bash
sudo apt install -y kubelet kubeadm kubectl
sudo systemctl enable kubelet
```

---

## **Step 5: Disable Swap and Configure Networking**

1. **Disable swap (Kubernetes requirement):**

```bash
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
```

2. **Configure kernel parameters:**

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system
```

---

## **Step 6: Initialize Kubernetes Cluster (Control Plane)**

1. **Initialize the control plane:**

```bash
sudo kubeadm init --cri-socket /run/containerd/containerd.sock --pod-network-cidr=192.168.0.0/16

```

2. **Set up `kubectl` for your user:**

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

---

### 🚨 **Issue: Kubernetes API Server Not Accessible**

The error:

```
The connection to the server localhost:8080 was refused
```

indicates that `kubectl` is not connecting to the Kubernetes API server. Additionally, the kubelet logs show:

```
"Container runtime network not ready"
```

which suggests issues with the container runtime (`containerd`).

---

## ✅ **Solution Steps**

### **Step 1: Grant Permission to `admin.conf`**

```bash
sudo chown $(id -u):$(id -g) /etc/kubernetes/admin.conf
sudo chmod 600 /etc/kubernetes/admin.conf
```

---

### **Step 2: Verify `kubectl` Configuration**

Ensure `kubectl` uses the correct kubeconfig:

```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
echo 'export KUBECONFIG=/etc/kubernetes/admin.conf' >> ~/.bashrc
source ~/.bashrc
```

---

Check if it is now pointing to the correct file:

```bash
kubectl config view
```

Since you are getting connection refused, the API server may not be running. Restart kubelet to reload control plane static pods:

```bash
sudo systemctl status containerd
sudo systemctl status kubelet
```

### **Step 3: Check Cluster Status**

```bash
kubectl cluster-info
kubectl get nodes
```

---

### 🚀 **If You Want to Use `sudo` Without Setting KUBECONFIG:**

```bash
sudo -i
kubectl cluster-info
```

---

### **Step 4 Verify Container Runtime Interface (CRI)**

Ensure that the kubelet is correctly configured to use `containerd`:

```bash
sudo cat /var/lib/kubelet/kubeadm-flags.env
```

It should include:

```
--container-runtime=remote --container-runtime-endpoint=unix:///run/containerd/containerd.sock
```

If missing, fix it by editing the kubelet configuration:

```bash
sudo mkdir -p /etc/systemd/system/kubelet.service.d
cat <<EOF | sudo tee /etc/systemd/system/kubelet.service.d/10-cri.conf
[Service]
Environment="KUBELET_EXTRA_ARGS=--container-runtime=remote --container-runtime-endpoint=unix:///run/containerd/containerd.sock"
EOF
```

Reload services:

```bash
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

---

### **Step 5: Check Kubernetes Control Plane Pods**

```bash
kubectl get pods -n kube-system
```

Ensure these are running:

- `etcd`
- `kube-apiserver`
- `kube-scheduler`
- `kube-controller-manager`

---

### **Step 6: Check Logs for `kube-apiserver` or `etcd`**

If pods are crashing:

```bash
kubectl logs -n kube-system etcd-k8s-master
kubectl logs -n kube-system kube-apiserver-k8s-master
```

---

### 🚀 **Final Check**

```bash
kubectl get nodes
kubectl get pods -n kube-system
```

Nodes should be `Ready`, and system pods should be running.

---

Would you like me to help you diagnose any pod logs if you still encounter issues? 😊🚀

### **Step 7: Install Pod Network (CNI)**

Choose a CNI (e.g., **Calico**):

https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart

---
