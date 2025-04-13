# Kubernetes Hierarchical Namespace Controller (HNC) Installation Guide

This guide provides step-by-step instructions to install or upgrade HNC (Hierarchical Namespace Controller) on your Kubernetes cluster. **Admin privileges** are required.

## Preparation, Twiddle with the existing namespaces to exclude for HNS operations

```
kubectl label ns kube-system hnc.x-k8s.io/excluded-namespace=true --overwrite
kubectl label ns kube-public hnc.x-k8s.io/excluded-namespace=true --overwrite
kubectl label ns kube-node-lease hnc.x-k8s.io/excluded-namespace=true --overwrite
```

## **1. Select HNC Version and Variant**

```bash
# Select the latest version of HNC
HNC_VERSION=v1.0.0

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

```bash
kubectl get svc -n hnc-system
```

- **Service and Endpoints:**  
  Run:
  ```bash
  kubectl get svc hnc-webhook-service -n hnc-system -o yaml
  kubectl get endpoints hnc-webhook-service -n hnc-system
  ```
  Confirm that the service is configured to expose port 443 and that its targetPort maps to 9443 (the port on which the webhook server is running in the pod). Also, verify that the endpoints are up and pointing to the correct pod IP and port.

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
#!/bin/bash
# Select the latest version of HNC
HNC_VERSION=v1.0.0
PLATFORM=linux_amd64

# Install HNC. Afterwards, wait up to 30s for HNC to refresh the certificates on its webhooks.
kubectl apply -f https://github.com/kubernetes-sigs/hierarchical-namespaces/releases/download/${HNC_VERSION}/default.yaml

# Protect critical namespaces that Kubernetes needs

kubectl label ns kube-system hnc.x-k8s.io/excluded-namespace=true --overwrite
kubectl label ns kube-public hnc.x-k8s.io/excluded-namespace=true --overwrite
kubectl label ns kube-node-lease hnc.x-k8s.io/excluded-namespace=true --overwrite

# The the hierarchical namespace manifest from GitHub and apply it to the cluster
# kubectl apply -f https://github.com/kubernetes-sigs/multi-tenancy/releases/download/hnc-$VERSION/hnc-manager.yaml

# Install HNC. Afterwards, wait up to 30s for HNC to refresh the certificates on its webhooks.
kubectl apply -f https://github.com/kubernetes-sigs/hierarchical-namespaces/releases/download/${HNC_VERSION}/default.yaml

# Take some time out for things to adjust
TIME_OUT=5
echo "Taking a break for $TIME_OUT seconds while Kubernetes refreshes itself..."
printf "Start time=$(date +'%s\n')"
sleep $TIME_OUT
printf "Start time=$(date +'%s\n')"

HNC_PLATFORM=linux_amd64 # also supported: linux_arm64, darwin_amd64, darwin_arm64, windows_amd64
curl -L https://github.com/kubernetes-sigs/hierarchical-namespaces/releases/download/${HNC_VERSION}/kubectl-hns_${HNC_PLATFORM} -o ./kubectl-hns
chmod +x ./kubectl-hns
# Install the plugin that allows kubectl to use the subcommand, his
#curl -L https://github.com/kubernetes-sigs/multi-tenancy/releases/download/hnc-$VERSION/kubectl-hns_$PLATFORM -o ./kubectl-hns

sudo mv kubectl-hns /bin
sudo chmod +x  /bin/kubectl-hns

# Execute the hns command. If all is well, you'll get the command line
# help documentation

kubectl hns
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

# **📌 Potential Issue.**

## HNC-manager POD Crush

## **Explanation of the Command:**

```sh
kubectl delete pod -n hnc-system -l control-plane=controller-manager
```

This command **deletes the HNC controller pod**, forcing Kubernetes to automatically recreate it.

#### **Breaking Down the Command:**

1️⃣ **`kubectl delete pod`** → Deletes a running pod.  
2️⃣ **`-n hnc-system`** → Specifies the **namespace** (`hnc-system`) where the pod is running.  
3️⃣ **`-l control-plane=controller-manager`** → Selects pods with the **label** `control-plane=controller-manager` (which identifies the HNC controller pod).

### **Why Use This Command?**

- Your **HNC pod is stuck in `CrashLoopBackOff`**, meaning it keeps failing and restarting.
- Deleting the pod allows Kubernetes to **create a new one** automatically (because Deployments manage pods).
- If the crash was due to a temporary issue, **the new pod may start successfully**.

### **What Happens After Running This?**

1️⃣ Kubernetes **immediately deletes the failing HNC pod**.  
2️⃣ The **HNC Deployment notices the missing pod** and automatically starts a new one.  
3️⃣ You can check the new pod with:

```sh
kubectl get pods -n hnc-system
```

Expected output:

```
NAME                                      READY   STATUS    RESTARTS   AGE
hnc-controller-manager-XXXXX              1/1     Running   0          10s
```

4️⃣ If the new pod **still crashes**, **HNC is broken and needs to be reinstalled**.

---

### **✅ Next Steps**

✔ Run:

```sh
kubectl get pods -n hnc-system
```

✔ If the pod **is still crashing**, reinstall HNC:

```sh
kubectl delete namespace hnc-system
kubectl apply -f https://github.com/kubernetes-sigs/hierarchical-namespaces/releases/latest/download/hnc-manager.yaml
```

---

Let me know if you need more explanation! 🚀
