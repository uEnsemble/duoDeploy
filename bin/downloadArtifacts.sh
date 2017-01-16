#!/bin/bash

# If github tag is set
if [ -n "$TRAVIS_TAG" ]; then
  # Put all work in here
  echo "tag set"
fi


# Get deployment event info from GH for payload (/repos/:owner/:repo/deployments/:deployment_id)
GH_EVENT_URL=$GH_BASE_URL/repos/$TRAVIS_REPO_SLUG/deployments/$TRAVIS_TAG
GH_DEPLOYMENT=$(curl -H "Authorization: token $GH_TOKEN" $GH_EVENT_URL)

#get the payload info
DEPLOYMENT_PAYLOAD=$(echo $GH_DEPLOYMENT | jq ".payload")
ARTIFACTS_ARRAY=$(echo $DEPLOYMENT_PAYLOAD | jq ".releases")
ARTIFACTS_ARRAY_LENGTH=$(echo $DEPLOYMENT_PAYLOAD | jq ". | length")

echo "Artifacts Array: $ARTIFACTS_ARRAY"

COUNTER=0
while [ "$COUNTER" -le "$ARTIFACTS_ARRAY_LENGTH" ]; do
  echo The counter is $COUNTER

  URL=$(echo $ARTIFACTS_ARRAY | jq ".[$COUNTER] ")
  
  #Strip these chararcters so curl/wget don't fail
  URL=$(echo $URL | sed s/\'//g | sed s/\"//g)

  let COUNTER=COUNTER+1

  echo "mkdir build$COUNTER"
  mkdir build$COUNTER

  echo "cd build$COUNTER"
  cd build$COUNTER
  
  echo "wget -O output.tz $URL"
  wget -O output.tz "$URL"

  echo "tar -xvzf output.tz"
  tar -xvzf output.tz

  echo "rm output.tz"
  rm output.tz

  echo "cd .."
  cd ..

done

