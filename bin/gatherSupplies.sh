#!/bin/bash

# If github tag is set
if [ -n "$TRAVIS_TAG" ]; then
  # Put all work in here
  echo "tag set"
fi

echo pwd
pwd

# Get deployment event info from GH for payload (/repos/:owner/:repo/deployments/:deployment_id)
GH_EVENT_URL=$GH_BASE_URL/repos/$TRAVIS_REPO_SLUG/deployments/$TRAVIS_TAG
echo "GH_EVENT_URL=$GH_EVENT_URL"
GH_DEPLOYMENT=$(curl -H "Authorization: token $GH_TOKEN" $GH_EVENT_URL)

#get the payload info
DEPLOYMENT_PAYLOAD=$(echo $GH_DEPLOYMENT | jq ".payload")
ARTIFACTS_ARRAY=$(echo $DEPLOYMENT_PAYLOAD | jq ".releases")
ARTIFACTS_ARRAY_LENGTH=$(echo $DEPLOYMENT_PAYLOAD | jq ". | length")

echo "DEPLOYMENT_PAYLOAD=$DEPLOYMENT_PAYLOAD"
echo "ARTIFACTS_ARRAY=$ARTIFACTS_ARRAY"
echo "ARTIFACTS_ARRAY_LENGTH=$ARTIFACTS_ARRAY_LENGTH"

COUNTER=0
while [ "$COUNTER" -le "$ARTIFACTS_ARRAY_LENGTH" ]; do
  echo The counter is $COUNTER

  URL=$(echo $ARTIFACTS_ARRAY | jq ".[$COUNTER] ")


  let COUNTER=COUNTER+1

  echo "mkdir build$COUNTER"
  mkdir build$COUNTER

  echo "cd build$COUNTER"
  cd build$COUNTER
  
  echo "wget -O output.tz $URL"
  wget -O output.tz "$URL"
  #echo "curl -L $URL > output.tz"
  #curl -L "$URL" > output.tz

  echo "tar -xvzf output.tz"
  tar -xvzf output.tz

  echo "rm output.tz"
  rm output.tz

  echo "cd .."
  cd ..

done

echo ls
ls

echo ls bin
ls bin


