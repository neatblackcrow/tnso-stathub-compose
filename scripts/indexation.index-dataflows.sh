#!/bin/sh 

# 1 positional param is sfs server address.
# 2 positional param is api's secret.
#Indexes dataflows of catagory schemes defined in datasources.json at 'queries' section
curl -X POST "http://${1:-'localhost:3004'}/admin/dataflows?api-key=${2:-secret}"
#Prints report of last indexation:
echo Results:
curl -X GET "http://${1:-'localhost:3004'}/admin/report?api-key=${2:-secret}"
