#!/bin/bash

scan_result=$(curl -sSX POST --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan)
scan_result=$(curl -sSX POST --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan | jq .[0].message -r)
scan_score=$(curl -sSX POST --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan | jq .[0].score)


if [[ "${scan_score}" -ge 5 ]]; then
    echo "Score is ${scan_score}"
    echo "Kubesec scan ${scan_message}"
else
    echo "Score is ${scan_score}, which is less than or equal to 5."
    echo "Scanning k8s resource has failed"
    exit 1;
fi
