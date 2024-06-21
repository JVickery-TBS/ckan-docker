#!/bin/bash

set -e

REDIS_HOST='redis-devm'
REDIS_CLUSTER='2'

printf "$(date -u +'%Y-%m-%d %H:%M:%S,%3N') INFO  [redis-swarm] Running awaiting queues in cluster ${REDIS_CLUSTER} on host ${REDIS_HOST}.\n";

# this will only match queue names that are 36 characters long, matching the Resource IDs.
redis-cli -h ${REDIS_HOST} -n ${REDIS_CLUSTER} --scan --pattern 'rq:queue:ckan:registry:[0-9a-z-]*' | grep 'rq:queue:ckan:registry:[0-9a-z-]\{36\}' | xargs -r -L1 echo | /srv/app/redis-swarm-worker.sh

printf "$(date -u +'%Y-%m-%d %H:%M:%S,%3N') INFO  [redis-swarm] Monitoring REDIS RPUSH in cluster ${REDIS_CLUSTER} on host ${REDIS_HOST}.\n";

redis-cli -h ${REDIS_HOST} -n ${REDIS_CLUSTER} monitor | stdbuf --output=0 grep "RPUSH" | /srv/app/redis-swarm-worker.sh
