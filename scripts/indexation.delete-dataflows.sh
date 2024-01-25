#!/bin/sh 

# 1 positional param is sfs server address.
# 2 positional param is api's secret.
curl -X DELETE http://${1:-'localhost:3004'}/admin/config?api-key=${2:-secret}
