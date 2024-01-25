#!/bin/sh 

# 1 positional param is sfs server address.
# 2 positional param is api's secret.
#Prints report of last indexaxion:
curl -X GET "http://${1:-'localhost:3004'}/admin/report?api-key=${2:-secret}"
