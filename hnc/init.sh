kubectl apply -f ./admin/db_config.yaml -n administration-namespace
kubectl apply -f ./admin/admin_config.yaml -n administration-namespace
kubectl apply -f ./admin/credentials.yaml -n administration-namespace
kubectl apply -f ./admin/deployment.yaml -n administration-namespace
kubectl apply -f ./admin/service.yaml -n administration-namespace

kubectl apply -f ./tenant-a/db_config.yaml -n tenant-namespace-a
kubectl apply -f ./tenant-a/tenant_config.yaml -n tenant-namespace-a
kubectl apply -f ./tenant-a/credentials.yaml -n tenant-namespace-a
kubectl apply -f ./tenant-a/deployment.yaml -n tenant-namespace-a
kubectl apply -f ./tenant-a/service.yaml -n tenant-namespace-a

kubectl apply -f ./tenant-b/db_config.yaml -n tenant-namespace-b
kubectl apply -f ./tenant-b/tenant_config.yaml -n tenant-namespace-b
kubectl apply -f ./tenant-b/credentials.yaml -n tenant-namespace-b
kubectl apply -f ./tenant-b/deployment.yaml -n tenant-namespace-b
kubectl apply -f ./tenant-b/service.yaml -n tenant-namespace-b