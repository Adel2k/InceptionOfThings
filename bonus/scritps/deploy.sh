k apply -f namespace.yaml
sudo snap install --classic

helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm install gitlab gitlab/gitlab \
  --namespace gitlab \
  --values gitlab-values.yaml
