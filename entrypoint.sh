#!/bin/sh

set -e

REPO_OWNER=`echo $GITHUB_REPOSITORY | cut -d'/' -f1`
REPO_NAME=`echo $GITHUB_REPOSITORY | cut -d'/' -f2`
REPO_SLUG=$REPO_SLUG/$REPO_NAME

case $INPUT_STATUS in
    "success")
        COLOR="good"
        TEXT_SUFFIX="completed *succesfully*"
    "failed")
        COLOR="danger"
        TEXT_SUFFIX="*failed*"
    "cancelled")
        COLOR="warning"
        TEXT_SUFFIX="been *cancelled*"
esac

TEXT="The workflow `$GITHUB_WORKFLOW` has $TEXT_SUFFIX"

curl -X POST -H "content-type: application/json" $INPUT_SLACK_URL \
    '{ attachments": [ { "color": "$COLOR", "text": "$TEXT", "fields": [{ "title": "Repository", "short": true, "value": "<https://github.com/$REPO_SLUG|$REPO_SLUG>" }, { "title": "Ref", "short": true, "value": "$GITHUB_REF" }], "actions": [ {"type": "button", "text": "Commit", "url": "https://github.com/$REPO_SLUG/commit/$GITHUB_SHA"}, { "type": "button", "text": "Commit", "url": "https://github.com/$REPO_SLUG/commit/$GITHUB_SHA/checks" }]}]}'