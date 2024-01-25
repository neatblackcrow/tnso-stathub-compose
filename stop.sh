#!/bin/sh 

docker compose -f docker-compose-js.yml -f docker-compose-dotnet.yml -f docker-compose-training.yml -f docker-compose-utilities.yml down
