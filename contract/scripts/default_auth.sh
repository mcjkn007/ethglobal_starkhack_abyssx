#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export RPC_URL="http://localhost:5050"

export WORLD_ADDRESS=$(cat ./manifests/dev/manifest.json | jq -r '.world.address')

export ACTIONS_ADDRESS=$(cat ./manifests/dev/manifest.json | jq -r '.contracts[] | select(.kind == "DojoContract" ).address')

echo "---------------------------------------------------------------------------"
echo world : $WORLD_ADDRESS 
echo " "
echo actions : $ACTIONS_ADDRESS
echo "---------------------------------------------------------------------------"

# List of the models.
MODELS=("User" "Role" "Name" "Card")

 
# Give permission to the action system to write on all the models.
for component in ${MODELS[@]}; do
	for address in ${ACTIONS_ADDRESS[@]}; do
		sozo auth grant writer $component,$address
	done
done
 
echo "Default authorizations have been successfully set."
