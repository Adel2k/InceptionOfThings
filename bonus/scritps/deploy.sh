k3d cluster create gitlab-cluster \
  --agents 2 \
  --port "8080:80@loadbalancer" \
  --port "8443:443@loadbalancer"


kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml

helm repo add traefik https://helm.traefik.io/traefik
helm repo update

helm install traefik traefik/traefik --namespace kube-system
helm repo add gitlab https://charts.gitlab.io/
helm repo update
kubectl create namespace gitlab
helm install gitlab gitlab/gitlab -f ../confs/gitlab-values.yaml --namespace gitlab
helm repo add gitlab-runner https://charts.gitlab.io/
helm repo update
kubectl create namespace gitlab-runner

helm install gitlab-runner gitlab-runner/gitlab-runner --namespace gitlab-runner
