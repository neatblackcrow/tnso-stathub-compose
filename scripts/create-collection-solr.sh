#!/bin/sh 

# This will automatically create a new Solr collection named after the default tenant (tnso).
# As well as create the required dynamic fields.
docker exec -it sfs sh -c 'cd /sfs; yarn dist:schema'

# 1 positional param is solr server address.
# 2 positional param is name of a collection. Usually the same as tenant name. In this case is 'tnso'.
# curl -X GET "http://${1:-localhost:8983}/solr/admin/collections?action=CREATE&name=${2:-tnso}&numShards=1&collection.configName=_default"

# Manually create following dynamic fields.
# "name": "*_sfs_[text|text_list]_${language}"
# "type": "text_${language}",
# "indexed": true,
# "multiValued": true,
# "stored": true

# Which expanded into ...
# *_sfs_text_en, *_sfs_text_list_en, *_sfs_text_th, *_sfs_text_list_th
# With following types.
# text_en, text_th

# curl -X POST -H 'Content-type:application/json' --data-binary '{
#     "add-dynamic-field": {
#         "name": "*_sfs_text_en",
#         "type": "text_en",
#         "indexed": true,
#         "multiValued": true,
#         "stored": true
#     }
# }' http://${1:-localhost:8983}/solr/${2:-tnso}/schema

# curl -X POST -H 'Content-type:application/json' --data-binary '{
#     "add-dynamic-field": {
#         "name": "*_sfs_text_list_en",
#         "type": "text_en",
#         "indexed": true,
#         "multiValued": true,
#         "stored": true
#     }
# }' http://${1:-localhost:8983}/solr/${2:-tnso}/schema

# curl -X POST -H 'Content-type:application/json' --data-binary '{
#     "add-dynamic-field": {
#         "name": "*_sfs_text_th",
#         "type": "text_th",
#         "indexed": true,
#         "multiValued": true,
#         "stored": true
#     }
# }' http://${1:-localhost:8983}/solr/${2:-tnso}/schema

# curl -X POST -H 'Content-type:application/json' --data-binary '{
#     "add-dynamic-field": {
#         "name": "*_sfs_text_list_th",
#         "type": "text_th",
#         "indexed": true,
#         "multiValued": true,
#         "stored": true
#     }
# }' http://${1:-localhost:8983}/solr/${2:-tnso}/schema