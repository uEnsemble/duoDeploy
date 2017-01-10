#!/bin/bash
STATUS="$1"
MESSAGE="$2"

if [ -n "$DEPLOY_STATUS_URL" ] ; then
  if [ -n "$TRAVIS_TAG" ] ; then
    curl -H "Authorization: token $GH_TOKEN" -H "Content-Type: application/json" -X POST "$DEPLOY_STATUS_URL" -d "{\"state\": \"$STATUS\",\"description\": \"$MESSAGE\"}"
  else
    echo "no tag/deployment id"
  fi
fi