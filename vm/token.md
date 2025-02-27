# 🚀 **Kubernetes Worker Node Token Management Guide**

In Kubernetes, **tokens** are used to join worker nodes to the control plane (`kubeadm join`). If you lose the token or it expires, you can regenerate or renew it.

---

## 📌 **1. View Existing Tokens**

Check all active join tokens:

```bash
kubeadm token list
```

Output example:

```
TOKEN                     TTL         EXPIRES                USAGES    DESCRIPTION
vebzn9.zqepd2g3kk8ba12x   23h         2025-02-15T14:00:00Z   authentication,signing   The default bootstrap token
```

---

## 📌 **2. Create a New Token**

If the token is missing or expired, create a new one:

```bash
kubeadm token create
```

Output example:

```
vebzn9.zqepd2g3kk8ba12x
```

---

## 📌 **3. Create a Token with Custom TTL**

By default, tokens are valid for **24 hours**. Set a custom TTL using `--ttl`:

### 🟡 **Example: Token Valid for 7 Days (168 hours):**

```bash
kubeadm token create --ttl 168h
```

### 🟡 **Example: Permanent Token (No Expiry):**

```bash
kubeadm token create --ttl 0
```

---

## 📌 **4. Get the `discovery-token-ca-cert-hash` (Needed for `kubeadm join`)**

The `kubeadm join` command requires both a token and the CA certificate hash for security.

1. Find the CA certificate hash:

```bash
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | \
  openssl rsa -pubin -outform DER 2>/dev/null | \
  openssl dgst -sha256 -hex | \
  sed 's/^.* //'
```

Example output:

```
sha256:6dif51087fb2289275286d67d08d05b9dd12a36bd4331793facf585e5403c804c
```

---

## 📌 **5. Regenerate the Full `kubeadm join` Command**

Get the entire join command easily:

```bash
kubeadm token create --print-join-command
```

Example output:

```bash
kubeadm join 10.184.0.5:6443 --token vebzn9.zqepd2g3kk8ba12x \
  --discovery-token-ca-cert-hash sha256:6dif51087fb2289275286d67d08d05b9dd12a36bd4331793facf585e5403c804c
```

---

## 📌 **6. Set Token TTL Permanently in Configuration**

If you want to control the token’s TTL every time the cluster is initialized or joined, create a `ClusterConfiguration` file.

### 🟡 **Example: `kubeadm-config.yaml`**

```yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
bootstrapTokens:
  - token: vebzn9.zqepd2g3kk8ba12x
    description: "Bootstrap token for joining nodes"
    ttl: "168h" # Token valid for 7 days
```

Then initialize the cluster:

```bash
kubeadm init --config kubeadm-config.yaml
```

---

## 📌 **7. Revoke a Token (Remove Access)**

If a token is compromised, revoke it:

```bash
kubeadm token delete vebzn9.zqepd2g3kk8ba12x
```

---

## 📌 **8. View All Approved Node Certificates**

Nodes request certificates when they join. View all certificate signing requests (CSRs):

```bash
kubectl get csr
```

---

## 📌 **9. Approve or Deny Node CSRs**

When nodes join, they generate CSRs. You can manually approve them:

```bash
kubectl certificate approve <csr-name>
```

Deny a suspicious request:

```bash
kubectl certificate deny <csr-name>
```

---

## 📌 **10. Monitor Token Expiration**

Check token expiration regularly with:

```bash
watch kubeadm token list
```

---

### 🚀 **Summary of Key Commands:**

| **Task**                 | **Command**                                               |
| ------------------------ | --------------------------------------------------------- |
| 📜 View existing tokens  | `kubeadm token list`                                      |
| ➕ Create a new token    | `kubeadm token create`                                    |
| ⏳ Token with custom TTL | `kubeadm token create --ttl 168h`                         |
| ♾️ Permanent token       | `kubeadm token create --ttl 0`                            |
| 🛡️ Get CA cert hash      | `openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt ...` |
| 📝 Full join command     | `kubeadm token create --print-join-command`               |
| ❌ Revoke a token        | `kubeadm token delete <token>`                            |
| ✅ Approve node CSR      | `kubectl certificate approve <csr-name>`                  |
| ❌ Deny node CSR         | `kubectl certificate deny <csr-name>`                     |

---

Would you like me to generate a **script** to automate token creation, monitoring, and renewal? 😊🚀
