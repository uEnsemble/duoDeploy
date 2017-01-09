#!/bin/bash
echo "Deployment to bluemix started"

ansible-playbook playbook.yml
rc=$?

#Don't exit != 0 or we cannot create new deploy events
if [[ $rc != 0 ]]; then
  echo "Deployment to bluemix failed"
else
  echo "Deployment to bluemix successful"
fi
