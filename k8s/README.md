# 🚀 How to Run and Deploy This Microservice App

⚠ **WARNING:** This app uses **local Docker images** and is **not pushed to a Docker registry** yet.

---

## 🛠 Step 1: Build the Docker Images

Each microservice requires its own **Docker image**. Follow these steps:

1. **Navigate to the application's directory** where the `Dockerfile` is located.
2. **Set up Minikube's Docker environment** by running:
   ```sh
   eval $(minikube docker-env)
   ```
3. **Build the Docker image locally**:
   ```sh
   docker build -t order-microservice:latest .
   ```
   Repeat this for each microservice by changing the image name accordingly.

---

## 🏗 Step 2: Apply Kubernetes Manifests

Move to the `k8s` directory and apply all Kubernetes YAML configurations **one by one**:
```sh
kubectl apply -f <YAML_NAME>
```

Repeat this for **each YAML file** in the `k8s` directory.

---

## 📜 Step 3: Check Running Pods

Verify that all pods are running inside their respective namespaces:
```sh
kubectl get pods -n app-admin
kubectl get pods -n app-x
kubectl get pods -n app-y
```

---

## 🔄 Step 4: Access Application Pods (SSH into Pods)

To connect to a running application pod:
```sh
kubectl exec -it <APP-POD-NAME> -n <NAMESPACE-OF-THE-APP> -- sh
```

Use the **pod name** retrieved from Step 3.

---

## 📌 Step 5: Run Database Migration Commands

Inside the application pod's shell (Step 4), run the following commands to generate and push database migrations:
```sh
npm run generate
npm run push
```

Ensure these commands **execute successfully** before proceeding.

---

## 🗄 Step 6: Verify Database Tables

1. **Check running database pods** under all namespaces:
   ```sh
   kubectl get pods -n db-admin
   kubectl get pods -n db-x
   kubectl get pods -n db-y
   ```

2. **Access the database shell** using the pod name retrieved in the previous step:
   ```sh
   kubectl exec -it <DB-POD-NAME> -n <NAMESPACE-OF-THE-DB-POD> -- sh
   ```

3. **Log into PostgreSQL**:
   ```sh
   psql -U postgres
   ```

4. **List all tables**:
   ```sh
   \dt
   ```

If the expected tables **exist**, then the application is **successfully deployed** and **ready to use**. 🎉

If tables are **missing**, there might be an error—**good luck debugging!** 🛠️🚀

