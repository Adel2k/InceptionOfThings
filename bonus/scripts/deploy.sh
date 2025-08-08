#!/bin/bash

set -e
set -o pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' 

CLUSTER_NAME="iot-cluster"

kubectl config use-context k3d-iot-cluster

#ArgoCD
echo -e "${CYAN}Deploying ArgoCD (if not installed)...${NC}"
if ! kubectl get deployment -n argocd argocd-server &>/dev/null; then
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  echo -e "${YELLOW}Waiting for ArgoCD to be ready...${NC}"
  kubectl wait --for=condition=available --timeout=180s deploy --all -n argocd
  echo -e "${GREEN}ArgoCD is ready!${NC}"
else
  echo -e "${GREEN}ArgoCD already deployed. Skipping installation.${NC}"
fi

#Deploying Application
echo -e "${CYAN}Deploying IoT application configs...${NC}"
kubectl apply -f ../confs/application.yaml
kubectl apply -f ../confs/deploy.yaml
kubectl apply -f ../confs/service.yaml

#Port Forwarding
echo -e "${CYAN}Port forwarding ArgoCD UI to http://localhost:8080 ...${NC}"
kubectl port-forward svc/argocd-server -n argocd 8080:443

PORT_FORWARD_PID=$!

#Password
echo -e "${CYAN}Initial ArgoCD password:${NC}"
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo > argoCD-password.txt
