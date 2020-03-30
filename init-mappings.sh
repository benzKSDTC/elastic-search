#!/bin/bash
BASENAME=`cat mapping.json`
evns=($ELASTICSEARCH_ENVS)
elasticsearchUrl=$ELASTICSEARCH_URL
exSuccess=false
exSuccessCheck=

echo $evns
for i in {30..0}; do
    for i in "${evns[@]}"; do
    echo ${i}
        if curl $elasticsearchUrl; then
            for row in $(echo "${BASENAME}" | jq -r '.[] | @base64'); do
                _jq() {
                echo ${row} | base64 --decode | jq -r ${1}
                }
            index=${i}_$(_jq '.index')
            echo $index
            curl -X PUT "$elasticsearchUrl/$index?pretty" -H 'Content-Type: application/json' -d"$(_jq '.mapping')"
            done
            exSuccessCheck+=true
            # break;
        fi
        sleep 2
    done
    if [ "$exSuccessCheck" != "" ]; then
        exSuccess=true
        break;
    fi
done

if [ $exSuccess = false ]; then 
    exit 64
fi
echo 'done'
