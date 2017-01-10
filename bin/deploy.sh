#!/bin/bash
echo "Deployment to bluemix started"

ansible-playbook playbook.yml
rc=$?

if [[ $rc != 0 ]]; then
  echo "Deployment to bluemix failed"
  exit $rc
else
  echo "Deployment to bluemix successful"
fi
