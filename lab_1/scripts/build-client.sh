#!/bin/bash

ENV_CONFIGURATION="production"
# ENV_CONFIGURATION=""

REPO="https://github.com/EPAM-JS-Competency-center/shop-angular-cloudfront.git"
REPO_FOLDER="shop-angular-cloudfront"
PATH_TO_REPO=".."
DIST_FOLDER="dist"
BUILD_FOLDER="app"
DIST_FILE="client-app.zip"
SCRIPT_FOLDER=$(pwd)

if [ ! -d "$PATH_TO_REPO/$REPO_FOLDER" ]; then
    cd $PATH_TO_REPO || exit
    git clone $REPO
    cd $REPO_FOLDER
else
    cd "$PATH_TO_REPO/$REPO_FOLDER"
fi

[ ! -d "node_modules" ] && npm install

npx ng build --configuration=$ENV_CONFIGURATION

cd $DIST_FOLDER

[ -f "$DIST_FILE" ] && rm $DIST_FILE

cd $BUILD_FOLDER
zip -r "../$DIST_FILE" .

echo "Calculating the content of the build folder..."
cd ../../
"$SCRIPT_FOLDER"/file-count.sh "$DIST_FOLDER/$BUILD_FOLDER"
