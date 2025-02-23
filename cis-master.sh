#!/bin/bash

total_fail=$(kube-bench run --targets master --version 1.20 --check 1.2.7,1.2.8,1.2.9 --json | jq .Totals.total_fail)

if [[ "$total_fail" -ne 0 ]]; then
    echo "CIS Benchmark Failed MASTER while testing for 1.2.7,1.2.8,1.2.9"
    exit 1;
else
    echo "CIS Benchmark Passed MASTER for 1.2.7,1.2.8,1.2.9"
fi
