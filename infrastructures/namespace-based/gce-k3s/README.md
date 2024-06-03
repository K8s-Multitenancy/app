# Applying the Kubernetes Topology

Steps to setup the Kubernetes cluster:
1. Run `kubectl apply -f namespace.yaml`
2. Run `kubectl apply -f deployment.yaml`
3. Run `kubectl apply -f service.yaml`
4. Verify and get the node ports by running `kubectl get svc --all-namespaces`