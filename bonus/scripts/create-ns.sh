set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' 


#Namespaces
echo -e "${CYAN}Creating namespaces...${NC}"
for ns in argocd dev gitlab gitlab-runner; do
  if kubectl get namespace "$ns" &>/dev/null; then
    echo -e "${GREEN}Namespace '$ns' already exists. Skipping.${NC}"
  else
    echo -e "${YELLOW}Creating namespace '$ns'...${NC}"
    kubectl apply -f ../confs/namespaces.yaml
  fi
done
