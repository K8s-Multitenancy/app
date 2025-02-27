# 🚀 **How to Set Up a Worker Node**

Since your **control plane (master node)** is up and running with essential pods (`CoreDNS`, `Calico`, `kube-apiserver`, etc.), the **next step** is to **join worker nodes** to the cluster. ✅

---

## 🛠️ **Steps to Add Worker Nodes to the Kubernetes Cluster:**

### 📌 **Step 1: Prepare the Worker Node**

- Ensure the **worker node** has:
  - **Ubuntu/Debian OS** installed
  - **`kubeadm`, `kubelet`, and `kubectl`** installed
  - **`containerd`** as the container runtime

**Install Kubernetes Tools on the Worker Node:**

```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl containerd
sudo systemctl enable kubelet
```

---

### 📌 **Step 2: Disable Swap on the Worker Node**

```bash
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
```

---

### 📌 **Step 3: Join Worker Node to the Cluster**

From your control plane node (`k8s-master`), you already have the join command from the `kubeadm init` output:

```bash
kubeadm join <IP:PORT Control Plane> \
  --token vebzn9.zqepd2g3kk8ba12x \
  --discovery-token-ca-cert-hash sha256:6dif51087fb2289275286d67d08d05b9dd12a36bd4331793facf585e5403c804c
```

**Run this command on the worker node as root:**

```bash
sudo kubeadm join <IP:PORT Control Plane> \
  --token vebzn9.zqepd2g3kk8ba12x \
  --discovery-token-ca-cert-hash sha256:6dif51087fb2289275286d67d08d05b9dd12a36bd4331793facf585e5403c804c
```

---

### 📌 **Step 4: Verify Worker Node in the Cluster**

Back on your **control plane node (`k8s-master`)**, check if the worker node joined successfully:

```bash
kubectl get nodes
```

You should see the worker node in the list with the status **`Ready`**:

```
NAME             STATUS   ROLES           AGE     VERSION
k8s-master       Ready    control-plane   10m     v1.30.10
worker-node-1    Ready    <none>          2m      v1.30.10
```

---

### 📌 **Step 5: Approve Certificate Signing Requests (if pending)**

Sometimes, you may need to manually approve the worker node’s certificate:

```bash
kubectl get csr
kubectl certificate approve <csr-name>
```

---

### 📌 **Step 6: Verify All Pods and Cluster Health**

Check system pods:

```bash
kubectl get pods -n kube-system
```

Check cluster information:

```bash
kubectl cluster-info
kubectl get nodes -o wide
```

---

### 💡 **Bonus: Add Labels to Worker Nodes**

For scheduling pods effectively:

```bash
kubectl label node worker-node-1 node-role.kubernetes.io/worker=worker
```

---

### 🚀 **Next Steps After Adding Worker Nodes:**

- ✅ Deploy a test application (`nginx` or `busybox`)
- ✅ Set up a **LoadBalancer** or **Ingress Controller** (e.g., NGINX Ingress)
- ✅ Configure **network policies** with Calico
- ✅ Add **monitoring** with **Prometheus and Grafana**

---

Would you like me to help you **generate the worker node join script** or set up **role-based access control (RBAC)** for your cluster? 😊🚀

---

## 🚨 **Issue:** `ip_forward` is Disabled on Worker Node

The error:

```bash
[ERROR FileContent--proc-sys-net-ipv4-ip_forward]: /proc/sys/net/ipv4/ip_forward contents are not set to 1
```

occurs because **`ip_forward`** (IP forwarding) is **disabled**, which prevents the worker node from routing traffic between pods and services.

---

## ✅ **Solution: Enable IP Forwarding on the Worker Node**

### 📌 **Step 1: Enable IP Forwarding Immediately**

Run this command to **immediately enable IP forwarding**:

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

---

### 📌 **Step 2: Make IP Forwarding Permanent**

To ensure the setting persists after reboot:

```bash
echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
sudo sysctl --system
```

---

### 📌 **Step 3: Verify IP Forwarding**

Check if `ip_forward` is now enabled:

```bash
sysctl net.ipv4.ip_forward
```

You should see:

```
net.ipv4.ip_forward = 1
```

---

### 📌 **Step 4: Retry the Worker Node Join Command**

Now try joining the cluster again:

```bash
sudo kubeadm join <IP:PORT Control Plane> \
  --token vebzn9.zqepd2g3kk8ba12x \
  --discovery-token-ca-cert-hash sha256:6dif51087fb2289275286d67d08d05b9dd12a36bd4331793facf585e5403c804c
```

---

### 📌 **Step 5: Verify Node Status on Master**

From the **master node**, check if the worker node joined successfully:

```bash
kubectl get nodes
```

You should see:

```
NAME             STATUS   ROLES           AGE     VERSION
k8s-master       Ready    control-plane   7h      v1.30.10
worker-node-1    Ready    <none>          2m      v1.30.10
```

---

### 💡 **Explanation: Why IP Forwarding is Needed:**

- **`net.ipv4.ip_forward`** allows the node to **route packets** between pods and services.
- Kubernetes networking (especially CNI plugins like **Calico**, **Flannel**, etc.) **requires `ip_forward` enabled** to connect pods across nodes.

---
