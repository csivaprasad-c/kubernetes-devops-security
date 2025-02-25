#!/usr/bin/env bash

echo $imageName

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity LOW,MEDIUM,HIGH --light $imageName
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity CRITICAL --light $imageName

exit_code=$?
echo "Exit code : ${exit_code}"

if [[ ${exit_code} == 1 ]]; then
  echo "Image scanning failed. Vulnerabilities found"
  exit 1;
else
  echo "Image scanning passed. No vulnerabilities found"
fi
