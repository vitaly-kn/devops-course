#!/bin/bash

if ! command -v jq &>/dev/null; then
    echo "JSON processor \"jq\" not found"
    echo "Please, refer to https://jqlang.github.io/jq/download/"
    echo "to get know how to install it on your system"
    exit 1
fi

FILENAME="$1"
[ ! -f "$FILENAME" ] && echo "$FILENAME not found!" && exit 1
shift

SANITIZED_OPTS=$(getopt -o '' -l branch:,owner:,repo:,poll-for-source-changes:,configuration:,help -- "$@")
[ $? -ne 0 ] && exit 1
eval set -- "$SANITIZED_OPTS"

CONFIGURATION=""
BRANCH="main"
OWNER=""
REPO=""
POLL="false"

help() {
    echo "Syntax: update-pipeline-definition.sh filename [options]"
    echo "Updates pipeline definition file"
    printf "\nArguments:\n"
    echo "  filename                               A JSON file containing pipeline definition"
    printf "\nOptions:\n"
    echo "  --branch string                        Update branch name. Default value is \"main\"."
    echo "  --owner string                         Update Owner field. No updates if omitted."
    echo "  --repo string                          Update Repo field. No updates if omitted."
    echo "  --poll-for-source-changes boolean      Update PollForSourceChanges name. Default value is \"false\"."
    echo "  --help                                 Print this help."
    echo
}

while true; do
    case "$1" in
    --branch)
        BRANCH="$2"
        shift 2
        ;;
    --owner)
        OWNER="$2"
        shift 2
        ;;
    --repo)
        REPO="$2"
        shift 2
        ;;
    --poll-for-source-changes)
        POLL="$2"
        shift 2
        ;;
    --configuration)
        CONFIGURATION="$2"
        shift 2
        ;;
    --help)
        help
        exit 0
        ;;
    --) break ;;
    esac
done

UPDATED_JSON="${FILENAME%.*}-$(date +%FT%T.%3N).json"

JQ_REQUEST="del(.metadata) | (.pipeline.version = .pipeline.version + 1)"
CONFIG_REQUEST="(.pipeline.stages[] | select (.name == \"Source\") | .actions[] | select (.name == \"Source\") | .configuration)"
JQ_REQUEST="$JQ_REQUEST | $CONFIG_REQUEST.Branch = \"$BRANCH\" | $CONFIG_REQUEST.PollForSourceChanges = \"$POLL\""

[ ! "$REPO" = "" ] && JQ_REQUEST="$JQ_REQUEST | $CONFIG_REQUEST.Repo = \"$REPO\""

[ ! "$OWNER" = "" ] && JQ_REQUEST="$JQ_REQUEST | $CONFIG_REQUEST.Owner = \"$OWNER\""

if [ ! "$CONFIGURATION" = "" ]; then
    ENV_REQUEST="(.pipeline.stages[].actions[].configuration | select(has(\"EnvironmentVariables\")).EnvironmentVariables )"
    ENV_REQUEST="$ENV_REQUEST |= ( fromjson | .[].value |= \"$CONFIGURATION\" | .[] | tostring)"
    JQ_REQUEST="$JQ_REQUEST | $ENV_REQUEST"
fi

jq "$JQ_REQUEST" "$FILENAME" >"$UPDATED_JSON"
