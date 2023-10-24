#!/bin/bash

REPO_FOLDER="shop-angular-cloudfront"
PATH_TO_REPO=".."

cd "$PATH_TO_REPO/$REPO_FOLDER" || exit

[ ! -d "node_modules" ] && npm install

echo "Auditing npm dependencies..."
npm audit

printf "\nRunning lint...\n"
npx ng lint

printf "\nPerfoming unit tests...\n"
npx ng test --watch=false
