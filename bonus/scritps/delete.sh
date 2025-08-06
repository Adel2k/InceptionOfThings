#!/bin/bash

echo "Deleting Helm releases..."

# Delete helm releases
helm uninstall gitlab --namespace gitlab
helm uninstall gitlab-runner --namespace gitlab-runner
helm uninstall traefik --namespace kube-system

echo "Deleting Kubernetes namespaces..."

# Delete namespaces
kubectl delete namespace gitlab
kubectl delete namespace gitlab-runner

echo "Deleting Traefik CRDs..."

# Optional: Only if you want to clean CRDs too
kubectl delete -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml

echo "Deleting k3d cluster..."

# Delete the k3d cluster
k3d cluster delete gitlab-cluster

echo "Cleanup complete!"
