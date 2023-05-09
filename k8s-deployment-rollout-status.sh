#!/bin/bash

sleep 60

if [[ $(kubectl -n default rollout status deploy ${deploymentName} --timeout 5s) != "deployment \"${deployementName}\" successfully rolled out" ]]; then
    echo "Deployment ${deploymentName} Rollout has failed"
    kubectl -n default rollout undo deploy ${deploymentName}
    exit 1;
else
    echo "Deployment ${deploymentName} rollout is success"
fi