# 🚀 How to Run and Deploy This Microservice App (Hierarchical Namespace Approach)

⚠ **WARNING:** This app uses **local Docker images** and is **not pushed to a Docker registry** yet.

---

## Step 0: Install HNC (Windows Guide)

1. Open **_elevated_** command prompt (Run as Administrator)
2. Run this command to apply HNC manifest:

    ```sh
    kubectl apply -f https://github.com/kubernetes-sigs/hierarchical-namespaces/releases/download/v1.1.0/default.yaml
    ```

3. Run this command to install the kubectl-hns plugin:

    ```sh
    curl -LO https://github.com/kubernetes-sigs/hierarchical-namespaces/releases/download/v1.1.0/kubectl-hns_windows_amd64.exe
    ```

4. Rename `kubectl-hns_windows_amd64.exe` to `kubectl-hns.exe`
5. Move `kubectl-hns.exe` to the folder of your choosing.
   (Suggestion: `C:\Users\YourUserName\.kubectl-hns\kubectl-hns.exe`)
6. Add this Environment Variables to your PATH (Edit System Environment Variables)

    ```sh
    %USERPROFILE%\.kubectl-hns
    ```

7. **CLOSE** and **REOPEN** Command Prompt. Verify the installation using these commands:

    ```sh
    kubectl get pods -n hnc-system
    ```

    **_Expected output_**: You should see the `hnc-controller-manager` pod in a Running state

    ```sh
    kubectl plugin list
    ```

    **_Expected output_**: `kubectl-hns` should be listed

    ```sh
    kubectl hns --help
    ```

    **_Expected output_**: You should see help information for kubectl-hns.

## 🛠 Step 1: Build the Docker Images

Each microservice requires its own **Docker image**. Follow these steps:

1. **Navigate to the application's directory** where the `Dockerfile` is located.
2. (MACOS) **Set up Minikube's Docker environment** by running:

   ```sh
   eval $(minikube docker-env)
   ```

   (WINDOWS) Skip this step

3. **Build the Docker image locally**:

   ```sh
   docker build -t order-microservice:latest .
   ```
   The image names defined in the yaml files are as follows:
   ```
   authentication-microservice:latest
   order-microservice:latest
   product-microservice:latest
   tenant-microservice:latest
   wishlist-microservice:latest
   ```

4. **_WINDOWS ONLY_**: **Load the image you built to minikube**:

    ```sh
    minikube image load order-microservice:latest
    ```

**_Repeat_** this for each microservice by changing the image name accordingly.

---

## 🏗 Step 2: Apply Kubernetes Manifests

Move to the `k8s` directory by
 ```sh
 cd k8s
 ```

First, start applying the namespaces

```sh
kubectl apply -f namespace.yaml
```

Execute each of the `hns set` commands found in that `namespace.yaml` file
```sh
kubectl hns set namespace-admin --parent=root-namespace
kubectl hns set namespace-tenant-x --parent=root-namespace
kubectl hns set namespace-tenant-y --parent=root-namespace
kubectl hns set db-admin --parent=namespace-admin
kubectl hns set db-x --parent=namespace-tenant-x
kubectl hns set db-y --parent=namespace-tenant-y
kubectl hns set app-admin --parent=namespace-admin
kubectl hns set app-x --parent=namespace-tenant-x
kubectl hns set app-y --parent=namespace-tenant-y
```

Go through each tenant folders, and apply ALL of the yaml files. (For example: admin)

```sh
cd admin
kubectl apply -f authentication-db.yaml -f authentication-deployment.yaml -f tenant-db.yaml -f tenant-deployment.yaml
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
