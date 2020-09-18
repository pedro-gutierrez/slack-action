#!/bin/sh

set -e

REPO_OWNER=`echo $GITHUB_REPOSITORY | cut -d'/' -f1`
REPO_NAME=`echo $GITHUB_REPOSITORY | cut -d'/' -f2`
REPO_SLUG=$REPO_OWNER/$REPO_NAME
REPO_URL="https://github.com/$REPO_SLUG"
COMMIT_URL="$REPO_URL/commit/$GITHUB_SHA"

case $INPUT_STATUS in
    "success")
        COLOR="good"
        TEXT_SUFFIX="completed *succesfully*"
        ;;
    "failed")
        COLOR="danger"
        TEXT_SUFFIX="*failed*"
        ;;
    "cancelled")
        COLOR="warning"
        TEXT_SUFFIX="been *cancelled*"
        ;;
    *)
        echo "Unsupported status $INPUT_STATUS"
        exit 1
        ;;
esac

TEXT="The workflow \`$GITHUB_WORKFLOW\` has $TEXT_SUFFIX"
PAYLOAD="{ \"attachments\": [ { \"color\": \"$COLOR\", \"text\": \"$TEXT\", \"fields\": [{ \"title\": \"Repository\", \"short\": true, \"value\": \"<$REPO_URL|$REPO_SLUG>\" }, { \"title\": \"Ref\", \"short\": true, \"value\": \"$GITHUB_REF\" }], \"actions\": [ {\"type\": \"button\", \"text\": \"Commit\", \"url\": \"$COMMIT_URL\"}, { \"type\": \"button\", \"text\": \"Action\", \"url\": \"$COMMIT_URL/checks\" }]}]}"

echo "Sending: $PAYLOAD"

curl -i -X POST -H "content-type: application/json" "$INPUT_SLACK_URL" -d "$PAYLOAD"