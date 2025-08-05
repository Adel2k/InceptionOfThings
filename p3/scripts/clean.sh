#!/bin/bash

set -e
set -o pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' 

CLUSTER_NAME="iot-cluster"

echo -e "${YELLOW}Starting cleanup of resources for cluster: ${CLUSTER_NAME}${NC}"

echo -e "${YELLOW}Deleting ArgoCD components...${NC}"
if kubectl get namespace argocd &>/dev/null; then
  kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml || true
  echo -e "${GREEN}ArgoCD components deleted.${NC}"
else
  echo -e "${GREEN}Namespace 'argocd' not found, skipping ArgoCD delete.${NC}"
fi

echo -e "${YELLOW}Deleting application manifests...${NC}"
kubectl delete -f ../confs/service.yaml || true
kubectl delete -f ../confs/deploy.yaml || true
kubectl delete -f ../confs/application.yaml || true

echo -e "${YELLOW}Deleting namespaces 'dev' and 'argocd'...${NC}"
kubectl delete namespace dev --ignore-not-found
kubectl delete namespace argocd --ignore-not-found

if k3d cluster list "$CLUSTER_NAME" &>/dev/null; then
  echo -e "${YELLOW}🧨 Deleting K3d cluster '${CLUSTER_NAME}'...${NC}"
  k3d cluster delete "$CLUSTER_NAME"
  echo -e "${GREEN}Cluster deleted: ${CLUSTER_NAME}${NC}"
else
  echo -e "${GREEN}Cluster '${CLUSTER_NAME}' does not exist, skipping deletion.${NC}"
fi

echo -e "${GREEN}Cleanup complete!${NC}"
