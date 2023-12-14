#!/bin/bash
docker buildx build -t nestjs_rest_api_a .
docker tag nestjs_rest_api_a vitalykn/nestjs_rest_api_a
docker push vitalykn/nestjs_rest_api_a
