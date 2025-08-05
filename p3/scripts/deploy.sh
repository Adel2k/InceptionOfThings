#!/bin/bash

set -e
set -o pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' 

CLUSTER_NAME="iot-cluster"

echo -e "${CYAN}Checking if cluster '$CLUSTER_NAME' exists...${NC}"
if k3d cluster list "$CLUSTER_NAME" &>/dev/null; then
  echo -e "${GREEN}Cluster '$CLUSTER_NAME' already exists. Skipping creation.${NC}"
else
  echo -e "${YELLOW}Creating cluster '$CLUSTER_NAME'...${NC}"
  k3d cluster create --config ../confs/k3d-cluster.yaml
fi

kubectl config use-context k3d-iot-cluster

echo -e "${CYAN}Creating namespaces...${NC}"
for ns in argocd dev; do
  if kubectl get namespace "$ns" &>/dev/null; then
    echo -e "${GREEN}Namespace '$ns' already exists. Skipping.${NC}"
  else
    echo -e "${YELLOW}Creating namespace '$ns'...${NC}"
    kubectl create namespace "$ns"
  fi
done

echo -e "${CYAN}Deploying ArgoCD (if not installed)...${NC}"
if ! kubectl get deployment -n argocd argocd-server &>/dev/null; then
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  echo -e "${YELLOW}Waiting for ArgoCD to be ready...${NC}"
  kubectl wait --for=condition=available --timeout=180s deploy --all -n argocd
  echo -e "${GREEN}ArgoCD is ready!${NC}"
else
  echo -e "${GREEN}ArgoCD already deployed. Skipping installation.${NC}"
fi

echo -e "${CYAN}Deploying IoT application configs...${NC}"
kubectl apply -f ../confs/application.yaml
kubectl apply -f ../confs/deploy.yaml
kubectl apply -f ../confs/service.yaml

echo -e "${CYAN}Port forwarding ArgoCD UI to http://localhost:8080 ...${NC}"
kubectl port-forward svc/argocd-server -n argocd 8080:443

# echo -e "${CYAN}Initial ArgoCD password:${NC}"
# kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo
