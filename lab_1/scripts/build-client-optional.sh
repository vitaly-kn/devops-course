#!/bin/bash

REPO="https://github.com/EPAM-JS-Competency-center/nestjs-rest-api.git"
REPO_FOLDER="nestjs-rest-api"
PATH_TO_REPO=".."
BUILD_FOLDER="dist"
SCRIPT_FOLDER=$(pwd)

if [ ! -d "$PATH_TO_REPO/$REPO_FOLDER" ]; then
    cd $PATH_TO_REPO || exit
    git clone $REPO
    cd $REPO_FOLDER
else
    cd "$PATH_TO_REPO/$REPO_FOLDER"
fi

[ ! -d "node_modules" ] && npm install

npm run build

echo "Calculating the content of the build folder..."
"$SCRIPT_FOLDER"/file-count.sh "$BUILD_FOLDER"
