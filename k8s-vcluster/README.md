# Setting Up a vCluster by Loft  

## Prerequisites  
Ensure you have the following installed:  
- **kubectl** ([Installation Guide](https://kubernetes.io/docs/tasks/tools/))  
- **Helm** ([Installation Guide](https://helm.sh/docs/intro/install/))  
**WINDOWS GUIDE**
  1. Install from `https://get.helm.sh/helm-v3.17.1-windows-amd64.zip`
  2. Extract the exe file and rename it to `helm.exe`
  3. Move `helm.exe` to `"C:\Users\YOURUSERNAME\.helm\helm.exe"` so that it can be accessed with %USERPROFILE%
  4. Add `%USERPROFILE%\.helm` to Environment Variables Path
  5. Verify installation by running `helm version` on CMD
- A running **Kubernetes cluster** (e.g., a local Minikube, Kind, or a cloud provider cluster)  

---

## Step-by-Step Guide  

### 1. Install vCluster
More info can be found here ([vCluster Docs](https://www.vcluster.com/docs/get-started?x0=1#deploy-vcluster))
- **Windows Guide**
  1. Install from `https://github.com/loft-sh/vcluster/releases/download/v0.23.0/vcluster-windows-amd64.exe` (Kemarin baru rilis v23, tapi gua pake v22.4. More releases check here [vCluster Releases](https://github.com/loft-sh/vcluster/releases))
  2. Extract the exe file and rename it to `vcluster.exe`
  3. Move `vcluster.exe` to `"C:\Users\YOURUSERNAME\.vcluster\vcluster.exe"` so that it can be accessed with %USERPROFILE%
  4. Add `%USERPROFILE%\.vcluster` to Environment Variables Path
  5. Verify installation by running `vcluster version` on CMD. (Make sure that you run Docker Desktop beforehand)

### 2. Run vCluster
0. Change directory inside `k8s-vcluster`
1. Apply namespaces in host machine
```sh
kubectl apply -f namespace.yaml
```
2. Create vCluster for each tenant
- Admin
```sh
  vcluster create admin-cluster --namespace ns-admin --connect=false
```
- Tenant X
```sh
  vcluster create x-cluster --namespace ns-x --connect=false
```
To connect to a vCluster, use
```sh
  vcluster connect <CLUSTERNAME> -n <NAMESPACE>
  # example: vcluster connect admin-cluster -n ns-admin
```
3. In each vCluster, apply the yaml files
```sh
  # connect to a vCluster if haven't already
  # example: vcluster connect admin-cluster -n ns-admin
  # then apply as usual
  kubectl apply -f admin/db_admin_configmap.yaml -f admin/db_admin_credentials.yaml -f admin/admin_configmap.yaml -f admin/admin_deployment.yaml -f admin/admin_service.yaml
```
  Do the same for other tenants

4. TODO: EXPOSE SERVICE