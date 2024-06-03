#!/bin/sh

# Install the required library via Homebrew
# brew install loft-sh/tap/vcluster-experimental

# Create namespaces
kubectl apply -f namespace.yaml

# Create virtual clusters
vcluster create test-vcluster --namespace namespace-admin --connect=false
vcluster create test-vcluster --namespace namespace-x --connect=false
vcluster create test-vcluster --namespace namespace-y --connect=false

# Deploy the admin virtual cluster
vcluster connect test-vcluster --namespace namespace-admin -- kubectl apply -f deployment_admin.yaml -f service_admin.yaml

# Deploy the first tenant virtual cluster
vcluster connect test-vcluster --namespace namespace-x -- kubectl apply -f deployment.yaml -f service.yaml

# Deploy the second tenant virtual cluster
vcluster connect test-vcluster --namespace namespace-y -- kubectl apply -f deployment.yaml -f service.yaml
