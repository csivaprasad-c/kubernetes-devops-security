#!/bin/bash

sleep 60

echo $(kubectl -n default rollout status deploy ${deploymentName} --timeout 5s)

if [[ $(kubectl -n default rollout status deploy ${deploymentName} --timeout 60s) != *"successfully rolled out"* ]];
then
    echo "Deployment ${deploymentName} Rollout has failed"
    kubectl -n default rollout undo deploy ${deploymentName}
    exit 1;
else
    echo "Deployment ${deploymentName} rollout is success"
fi
