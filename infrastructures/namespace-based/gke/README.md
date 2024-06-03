# Applying the Kubernetes Topology

Before applying the topology using the `kubectl apply` command, we should create an IngressController because of the amount of external IP needed exceeds the limit set by Google.
1. Run `helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx` and followed by `helm repo update` to add the ingress-nginx repository to your Helm installation. If you don't have Helm installed yet, please visit [this webpage](https://helm.sh/docs/) and follow the instructions given.
2. Afterwards, run `helm install <RELEASE_NAME> ingress-nginx/ingress-nginx --namespace <NAMESPACE_NAME> --create-namespace --set controller.ingressClassByName=true --set controller.ingressClassResource.name=<RELEASE_NAME> --set controller.ingressClassResource.controllerValue="k8s.io/<RELEASE_NAME>" --set controller.ingressClassResource.enabled=true --set controller.replicaCount=2`. Don't forget to change the `RELEASE_NAME` and `NAMESPACE_NAME`.

Steps to setup the Kubernetes cluster:
1. If you didn't create an IngressController in step 2, then run `kubectl apply -f namespace.yaml`
2. Run `kubectl apply -f deployment.yaml`
3. Run `kubectl apply -f service.yaml`
4. Run `kubectl apply -f ingress.yaml`
5. Verify and get the external IP addresses by running `kubectl get svc --all-namespaces`