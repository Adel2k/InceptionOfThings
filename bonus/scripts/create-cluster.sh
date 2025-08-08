set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' 

CLUSTER_NAME="iot-cluster"

#Cluster
echo -e "${CYAN}Checking if cluster '$CLUSTER_NAME' exists...${NC}"
if k3d cluster list "$CLUSTER_NAME" &>/dev/null; then
  echo -e "${GREEN}Cluster '$CLUSTER_NAME' already exists. Skipping creation.${NC}"
else
  echo -e "${YELLOW}Creating cluster '$CLUSTER_NAME'...${NC}"
  k3d cluster create --config ../confs/k3d-cluster.yaml
fi