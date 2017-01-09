#!/bin/bash

# If github tag is set
if [ -n "$TRAVIS_REPO_SLUG" ]; then
  # Put all work in here
  echo "tag set"
fi


# Get deployment event info from GH for payload (/repos/:owner/:repo/deployments/:deployment_id)
GH_EVENT_URL=$GH_BASE_URL/repos/$TRAVIS_REPO_SLUG/deployments/$TRAVIS_TAG
GH_DEPLOYMENT=$(curl -H "Authorization: token $GH_TOKEN" $GH_EVENT_URL)

#get the payload info
DEPLOYMENT_PAYLOAD=$(echo $GH_DEPLOYMENT | jq ".deployment | .payload")
ARTIFACTS_ARRAY=$(echo $DEPLOYMENT_PAYLOAD | jq ".releases")
ARTIFACTS_ARRAY_LENGTH=$(echo $DEPLOYMENT_PAYLOAD | jq ". | length")

echo "DEPLOYMENT_PAYLOAD=$DEPLOYMENT_PAYLOAD"
echo "ARTIFACTS_ARRAY=$ARTIFACTS_ARRAY"
echo "ARTIFACTS_ARRAY_LENGTH=$ARTIFACTS_ARRAY_LENGTH"

COUNTER=0
while [ $COUNTER -lt $ARTIFACT_ARRAY_LENGTH ]; do
  echo The counter is $COUNTER
  let COUNTER=COUNTER+1

  URL=$(echo ARTIFACTS_ARRAY | jq ".[0] | .url ")

  mkdir build$COUNTER

  cd build$COUNTER
  curl -L $URL > output.tz
  tar -xvzf output.tz
  rm output.tz
  cd ..

done

