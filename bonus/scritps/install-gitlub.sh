#!/bin/bash

set -e  # Exit on any error
set -o pipefail

# 1. Create namespace
kubectl create ns gitlab || true

# 2. Add GitLab Helm repo and update
helm repo add gitlab https://charts.gitlab.io/ || true
helm repo update

# 3. Define version
GITLAB_VERSION="7.11.2"

# 4. Install GitLab with minimal config
helm install gitlab gitlab/gitlab \
  --namespace gitlab --create-namespace \
  --set global.gitlab.webservice.externalUrl="http://localhost:8080" \
  --set global.gitlab.webservice.externalPort=8080 \
  --set global.hosts.domain=localhost \
  --set global.hosts.externalIP=127.0.0.1 \
  --set global.ingress.enabled=false \
  --set global.ingress.configureCertmanager=false \
  --set nginx-ingress.enabled=false \
  --set certmanager.install=false \
  --set gitlab-runner.install=false

# 5. Wait for GitLab webservice to become ready
echo "⏳ Waiting for GitLab webservice to roll out..."
kubectl -n gitlab rollout status deploy gitlab-webservice-default --timeout 5m

# 6. OPTIONAL: Add domain to local machine (Linux/macOS)
# echo "127.0.0.1 gitlab.k8s.orb.local" | sudo tee -a /etc/hosts

# 7. Test GitLab endpoint (insecure because of self-signed cert)
echo "🌐 Testing GitLab endpoint..."
curl -vk https://gitlab.k8s.orb.local

# 8. Save self-signed certificate for browser import (optional)
kubectl get secret -n gitlab gitlab-wildcard-tls-ca -o jsonpath='{.data.cfssl_ca}' | base64 --decode > gitlab.k8s.orb.local.ca.pem

echo "✅ GitLab should be available at: https://gitlab.k8s.orb.local"
