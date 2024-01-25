#!/bin/sh 

echo 'Do not use this script anymore. All configurations in "tenants.json" and all config files under the tenant "nso" must be updated manually.'
echo 'Since only the URLs which needed to be called on the client side (js, external api calls, etc) are named (DNS).'
echo 'Everything else should be hard coded with Docker host IP, because they are internal container communications. Either directly amoung containers 
in their subnet or passed through Docker host (FORWARD chain).'

read -p 'Do you wish to continue? (press "y" to confirm): ' confirm
if [ $confirm != 'y' ]; then
    exit 0
fi

echo "Working folder .... : "$1
echo "Replace host to ... : "$2
echo "Replace host from . : "$3
echo "JSON files detected :"
find $1 -type f -name "tenants.json"
find $1 -type f -name "datasources.json"

find $1 -type f -name "settings.json" -exec sed -Ei 's#"http://localhost:3004/api"|"http://'$3':3004/api"#"http://'$2':3004/api"#g' {} +

find $1 -type f -name "settings.json" -exec sed -Ei 's#"http://localhost:7002"|"http://'$3':7002"#"http://'$2':7002"#g' {} +

find $1 -type f -name "settings.json" -exec sed -Ei 's#"http://localhost:3005/api"|"http://'$3':3005/api"#"http://'$2':3005/api"#g' {} +

find $1 -type f -name "settings.json" -exec sed -Ei 's#"http://localhost:3005"|"http://'$3':3005"#"http://'$2':3005"#g' {} +

find $1 -type f -name "settings.json" -exec sed -Ei 's#"http://'$3':7001"#"http://'$2':7001"#g' {} +

find $1 -type f -name "tenants.json" -exec sed -Ei 's#"http://'$3:'#"http://'$2:'#g' {} +
find $1 -type f -name "tenants.json" -exec sed -Ei 's#"http://'$3/'#"http://'$2/'#g' {} +

echo "JSON configuration files updated with the following host address: "$2

