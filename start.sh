#!/bin/bash 

##################
# Initialization #
##################
HOST='172.19.2.57'
DIR_CONFIG='./config'

# Re-initialize js configuration
./scripts/init.config.mono-tenant.two-dataspaces.sh $HOST

# Apply host value at KEYCLOAK_HOST variable in ENV file
# sed -Ei "s#^KEYCLOAK_HOST=.*#KEYCLOAK_HOST=$HOST#g" .env

# Apply host value at HOST variable in ENV file
sed -Ei "s#^HOST=.*#HOST=$HOST#g" .env

#########################
# Start docker services #
#########################

echo "Prepopulate persistent-data directory."
mkdir -p ./persistent-data/solr/
cp -n ./solr-config/{solr.xml,zoo.cfg} ./persistent-data/solr/
chown 8983:8983 -R ./persistent-data/solr/

# Beware of the orders of compose files passed via -f option. The latter overrides the former. Optional *.override.yml naming convention can be used.
echo "Starting .Net services, JS services, Utilities, Training"
docker compose -f docker-compose-dotnet.yml -f docker-compose-js.yml -f docker-compose-training.yml -f docker-compose-utilities.yml up -d

echo "Services started:"
docker ps
