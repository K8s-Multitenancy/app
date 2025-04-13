Untuk **menghapus HNC (Hierarchical Namespace Controller) dan HNS (Hierarchical Namespace)** dari cluster Kubernetes, ikuti langkah-langkah berikut:

---

### **1. Hapus CRDs (Custom Resource Definitions)**

HNC menggunakan beberapa CRD, jadi kamu perlu menghapusnya terlebih dahulu:

```bash
kubectl delete crd hierarchicalresourcequotas.hnc.x-k8s.io
kubectl delete crd hierarchyconfigurations.hnc.x-k8s.io
kubectl delete crd hncconfigurations.hnc.x-k8s.io
kubectl delete crd subnamespaceanchors.hnc.x-k8s.io
```

---

### **2. Hapus Namespace `hnc-system`**

Namespace ini digunakan oleh HNC dan harus dihapus:

```bash
kubectl delete namespace hnc-system
```

Jika namespace tidak terhapus karena finalizer, hapus finalizer secara manual:

```bash
kubectl patch namespace hnc-system -p '{"metadata":{"finalizers":[]}}' --type=merge
kubectl delete namespace hnc-system
```

---

### **3. Hapus RBAC, Webhooks, dan Service**

HNC membuat beberapa role, bindings, dan webhook yang perlu dihapus:

```bash
kubectl delete clusterrole hnc-admin-role hnc-manager-role
kubectl delete clusterrolebinding hnc-manager-rolebinding
kubectl delete mutatingwebhookconfiguration hnc-mutating-webhook-configuration
kubectl delete validatingwebhookconfiguration hnc-validating-webhook-configuration
kubectl delete service hnc-webhook-service -n hnc-system
```

---

### **4. Hapus Deployment dan Pods HNC**

Terakhir, hapus deployment `hnc-controller-manager`:

```bash
kubectl delete deployment hnc-controller-manager -n hnc-system
```

---

### **5. Verifikasi Penghapusan**

Pastikan semua komponen HNC sudah terhapus:

```bash
kubectl get all -n hnc-system
kubectl get crd | grep hnc
kubectl get namespace | grep hnc-system
```

Jika semuanya sudah hilang, berarti **HNC sudah berhasil dihapus dari cluster** 🎉.
