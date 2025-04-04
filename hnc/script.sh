kubectl apply -f db_config.yaml -n admin
kubectl apply -f admin_config.yaml -n admin
kubectl apply -f credentials.yaml -n admin

kubectl apply -f deployment.yaml -n admin
kubectl apply -f service.yaml -n admin



kubectl apply -f db_config.yaml -n tenant-a
kubectl apply -f tenant_config.yaml -n tenant-a
kubectl apply -f credentials.yaml -n tenant-a

kubectl apply -f deployment.yaml -n tenant-a
kubectl apply -f service.yaml -n tenant-a



kubectl apply -f db_config.yaml -n tenant-b
kubectl apply -f tenant_config.yaml -n tenant-b
kubectl apply -f credentials.yaml -n tenant-b

kubectl apply -f deployment.yaml -n tenant-b
kubectl apply -f service.yaml -n tenant-b