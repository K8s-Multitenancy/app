Tentu! Ini aku rapikan jadi format dokumentasi `.md` yang rapi, jelas, dan cocok buat langsung dipakai:  
Aku juga perbaiki flow dan konsistensi markdown-nya supaya enak dibaca.

Berikut hasilnya:

---

# 📈 Installing Prometheus Operator on Kubernetes Using Helm

This guide provides a step-by-step tutorial on how to install the **Prometheus Operator** (via `kube-prometheus-stack`) on a Kubernetes cluster using Helm.

---

## 📦 Step 1: Install Helm

### 1.1 Download Helm

For Linux (amd64):

```bash
curl -LO https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gz
```

### 1.2 Extract the Helm archive

```bash
tar -zxvf helm-v3.17.3-linux-amd64.tar.gz
```

### 1.3 Move Helm to the correct location

```bash
sudo mv linux-amd64/helm /usr/local/bin/helm
```

### 1.4 Verify the Helm installation

Check the Helm version:

```bash
helm version
```

You should see output similar to:

```bash
version.BuildInfo{Version:"v3.17.3", GitCommit:"e4da49785aa6e6ee2b86efd5dd9e43400318262b", GitTreeState:"clean", GoVersion:"go1.23.7"}
```

---

## 🚀 Step 2: Install Prometheus Operator

### 2.1 Add the Prometheus community Helm repository

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

### 2.2 Update your Helm repositories

```bash
helm repo update
```

### 2.3 Install the Prometheus Operator (kube-prometheus-stack)

```bash
helm install prometheus-operator prometheus-community/kube-prometheus-stack
```

---

## 🎨 Step 3: Expose Grafana Service Using NodePort

By default, the Grafana service is installed as `ClusterIP`. To make it accessible externally, we will edit it to `NodePort`.

### 3.1 Edit the Grafana service

```bash
kubectl edit svc prometheus-operator-grafana
```

### 3.2 In the `vim` editor

Find the line:

```yaml
type: ClusterIP
```

Enter **Insert Mode** by pressing:

```
i
```

Change it to:

```yaml
type: NodePort
```

### 3.3 Save and Exit `vim`

- Press `Esc`
- Type:

```bash
:wq
```

and press **Enter**.

---

## 🔎 Step 4: Check the NodePort and Access Grafana

### 4.1 Check the service

```bash
kubectl get svc prometheus-operator-grafana
```

Example output:

```
NAME                        TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
prometheus-operator-grafana NodePort   10.96.180.243  <none>        80:31300/TCP     5m
```

**In this case**, NodePort is `31300`.

### 4.2 Access Grafana in Browser

Suppose your VM IP is `192.168.56.101`. Access Grafana at:

```
http://192.168.56.101:31300
```

---

## 🔐 Step 5: Get Grafana Admin Password

The Grafana credentials are automatically generated. You can retrieve the admin password with:

```bash
kubectl get secret prometheus-operator-grafana -o jsonpath="{.data.admin-password}" | base64 -d; echo
```

The default username is usually `admin`.

If you want to see both username and password encoded in Base64, you can inspect the full secret:

```bash
kubectl get secret prometheus-operator-grafana -o yaml
```

Look for:

```yaml
data:
  admin-user: YWRtaW4= # Base64 for "admin"
  admin-password: <base64-encoded-password>
```

---

## ⚙️ Optional: Set Custom Admin Password

To set your own password during installation, you can add the following parameter when installing:

```bash
helm install prometheus-operator prometheus-community/kube-prometheus-stack --set grafana.adminPassword=yourpassword
```

Or, if already installed, use `helm upgrade`:

```bash
helm upgrade prometheus-operator prometheus-community/kube-prometheus-stack --set grafana.adminPassword=yourpassword
```

---

# ✅ Done!

You now have the Prometheus Operator and Grafana up and running in your Kubernetes cluster, accessible via NodePort! 🚀
