set -e

kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik --namespace kube-system

helm repo add gitlab https://charts.gitlab.io/
helm repo update

helm install gitlab gitlab/gitlab -f ../confs/gitlab-values.yaml --namespace gitlab
helm repo add gitlab-runner https://charts.gitlab.io/
helm repo update


helm install gitlab-runner gitlab-runner/gitlab-runner -f ../confs/gitlab-runner-values.yaml --namespace gitlab-runner

kubectl port-forward -n gitlab svc/gitlab-webservice-default 8080:8080

kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -o jsonpath="{.data.password}" | base64 --decode && echo > gitlab-password.txt
