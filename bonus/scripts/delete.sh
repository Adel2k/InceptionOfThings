set -e
echo "Deleting Helm releases..."

helm uninstall gitlab -n gitlab || true
helm uninstall gitlab-runner -n gitlab-runner || true
helm uninstall traefik -n kube-system || true

echo "Deleting Kubernetes namespaces..."

kubectl delete namespace gitlab 
kubectl delete namespace gitlab-runner 
kubectl delete namespace argocd 
kubectl delete namespace dev 


echo "Deleting Traefik CRDs..."

kubectl delete -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml

echo "Deleting k3d cluster..."

k3d cluster delete iot-cluster
docker container prune -f
docker network prune -f

echo "Cleanup complete!"
