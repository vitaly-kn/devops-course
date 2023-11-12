#!/bin/bash

REPO_FOLDER="nestjs-rest-api"
PATH_TO_REPO=".."

cd "$PATH_TO_REPO/$REPO_FOLDER" || exit

[ ! -d "node_modules" ] && npm install

echo "Auditing npm dependencies..."
npm audit

printf "\nRunning lint...\n"
npm run lint

printf "\nPerfoming unit tests...\n"
npm run test
