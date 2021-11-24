#! /bin/bash

systemctl is-enabled kplex && systemctl restart kplex

sleep 1

systemctl is-enabled signalk && systemctl restart signalk
