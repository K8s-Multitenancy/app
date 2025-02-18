## **1️⃣ Use Kubernetes Secrets for Sensitive Data**

Secrets are ideal for storing sensitive information like passwords and API keys.

### **📌 Step 1: Create a Secret**

`EXP:` Run the following command to create a Secret that stores database credentials or any secret key:

```sh
kubectl create secret generic db-credentials --namespace=<xxx> \
  --from-literal=JWT_SECRET=<secret> \
  --from-literal=DB_USER=<password> \
  --from-literal=DB_PASSWORD=<password>
```

### **📌 Step 2: How to Use Secrets**

How to reference the Secret:

```yaml
env:
  - name: JWT_SECRET
    valueFrom:
      secretKeyRef:
        name: db-credentials
        key: JWT_SECRET
  - name: DB_USER
    valueFrom:
      secretKeyRef:
        name: db-credentials
        key: DB_USER
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: db-credentials
        key: DB_PASSWORD
```

## **2️⃣ Use ConfigMaps for Non-Sensitive Configuration**

For configuration values that **are not sensitive**, like `DB_HOST` and `DB_PORT`, use a ConfigMap.

### **📌 Step 1: Create a ConfigMap**

`EXP:` Create a ConfigMap to store database-related configuration:

```sh
kubectl create configmap db-config --namespace=<xxx> \
  --from-literal=DB_HOST=<publicIP/DB_host> \
  --from-literal=DB_NAME=<dbname> \
  --from-literal=DB_PORT=<dbport>
```

### **📌 Step 2: How to Use ConfigMap**

How to reference the ConfigMap:

```yaml
env:
  - name: DB_HOST
    valueFrom:
      configMapKeyRef:
        name: db-config
        key: DB_HOST
  - name: DB_NAME
    valueFrom:
      configMapKeyRef:
        name: db-config
        key: DB_NAME
  - name: DB_PORT
    valueFrom:
      configMapKeyRef:
        name: db-config
        key: DB_PORT
```

## **Summary**

✅ **Use Secrets** for sensitive data (passwords, tokens, API keys).  
✅ **Use ConfigMaps** for non-sensitive configurations (hostnames, ports, etc.).  
✅ **Combine both** for a more secure and flexible configuration.
