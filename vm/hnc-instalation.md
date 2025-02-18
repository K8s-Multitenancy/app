# Kubernetes Hierarchical Namespace Controller (HNC) Installation Guide

This guide provides step-by-step instructions to install or upgrade HNC (Hierarchical Namespace Controller) on your Kubernetes cluster. **Admin privileges** are required.

## **1. Select HNC Version and Variant**

```bash
# Select the latest version of HNC
HNC_VERSION=v1.1.0

# Select the variant of HNC you like. Options include:
# 'default': Standard version.
# 'hrq': With hierarchical quotas.
# 'ha': High availability with two deployments.
# 'default-cm': For cert-manager integration.
HNC_VARIANT=default
```

## **2. Install HNC on Kubernetes Cluster**

```bash
# Apply the selected HNC variant
kubectl apply -f https://github.com/kubernetes-sigs/hierarchical-namespaces/releases/download/${HNC_VERSION}/${HNC_VARIANT}.yaml
```

⚠️ **Warning:** If your cluster already has HNC installed, ensure you are using **v1.0.0 or later** before upgrading to v1.1.0.

**Verification:**

```bash
kubectl get pods -n hnc-system
```

You should see the HNC controller pods running.

---

## **3. Install the `kubectl-hns` Plugin**

### **Option 1: Install via Krew (Recommended)**

Ensure that [Krew](https://krew.sigs.k8s.io/) is installed.

```bash
# Update Krew and install the HNS plugin
kubectl krew update && kubectl krew install hns
```

### **Option 2: Manual Installation**

```bash
# Ensure HNC_VERSION is set as above
HNC_PLATFORM=linux_amd64 # Options: linux_arm64, darwin_amd64, darwin_arm64, windows_amd64

# Download the kubectl-hns binary
curl -L https://github.com/kubernetes-sigs/hierarchical-namespaces/releases/download/${HNC_VERSION}/kubectl-hns_${HNC_PLATFORM} -o ./kubectl-hns

# Make it executable
chmod +x ./kubectl-hns

# Move it to a directory in your PATH
sudo mv ./kubectl-hns /usr/local/bin/
```

---

## **4. Verify the Installation**

```bash
# Verify the plugin works
kubectl hns --help
```

**Expected Output:**

```text
Manage hierarchical namespaces.

Usage:
  kubectl hns [flags]
  kubectl hns [command]

Available Commands:
  create      Creates a subnamespace under the specified namespace
  delete      Deletes a subnamespace
  tree        Shows the hierarchy tree
  set         Sets properties of the namespace
```

---

## **5. Common Commands**

### **Create a Subnamespace:**

```bash
kubectl hns create dev -n tenant-a
kubectl hns create prod -n tenant-a
```

### **View Namespace Tree:**

```bash
kubectl hns tree tenant-a
```

**Example Output:**

```
tenant-a
├── dev
└── prod
```

### **Delete a Subnamespace:**

```bash
kubectl hns delete dev -n tenant-a
```

### **Allow Namespace Creation:**

```bash
kubectl annotate ns tenant-a hnc.x-k8s.io/allow=true
```

---

## **6. Troubleshooting**

### **1. Check HNC Controller Status**

```bash
kubectl get pods -n hnc-system
```

### **2. Restart HNC Controller**

```bash
kubectl rollout restart deployment hnc-controller-manager -n hnc-system
```

### **3. Check Plugin Installation**

```bash
kubectl plugin list
```

### **4. Check Logs for Errors**

```bash
kubectl logs -n hnc-system -l app=hnc-controller-manager
```

---

🎉 **Congratulations!** You have successfully installed and configured Hierarchical Namespace Controller (HNC) in your Kubernetes cluster!
