#!/bin/bash
BASENAME=`cat mapping.json`
elasticsearchUrl=$ELASTICSEARCH_URL
exSuccess=false

for i in {30..0}; do
    if curl $elasticsearchUrl; then
        for row in $(echo "${BASENAME}" | jq -r '.[] | @base64'); do
            _jq() {
            echo ${row} | base64 --decode | jq -r ${1}
            }
        curl -X PUT "$elasticsearchUrl/$(_jq '.index')?pretty" -H 'Content-Type: application/json' -d"$(_jq '.mapping')"
        done
        exSuccess=true
        break;
    fi
    sleep 2
done

if [ $exSuccess = false ]; then 
    exit 64
fi
echo 'done'
