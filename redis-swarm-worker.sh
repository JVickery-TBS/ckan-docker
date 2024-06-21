#!/bin/bash

set -e

CKAN_SITE_ID='registry'
REDIS_WORKER_TIMEOUT=15

while read line
do
  # parse the queue name from the standard buffer from the redis-cli monitor, it will only pass in lines for RPUSH.
  # this will also only match queue names that are 36 characters long, matching the Resource IDs.
  QUEUE_NAME=$(echo $line | grep -o "rq:queue:ckan:${CKAN_SITE_ID}:[0-9a-z-]\{36\}" | awk -F '[:]' '{print $5}');
  # need to parse ps from running job pids to expand variables.
  RUNNING_PID=$(jobs -pr | xargs -r -L1 ps -o "pid,args" | tail -n+2 | grep "${QUEUE_NAME}" | awk '{print substr($0, index($0, $1), index($0, $1))}');
  if [[ "${RUNNING_PID}" ]]; then
    # there is already a job running the queue worker.
    printf "$(date -u +'%Y-%m-%d %H:%M:%S,%3N') INFO  [redis-swarm-worker] Worker for Resource ${QUEUE_NAME} is already running on PID ${RUNNING_PID}. Do not need to bring up another worker.\n";
  else
    # there is no running job for the queue worker, make a new one.
    printf "$(date -u +'%Y-%m-%d %H:%M:%S,%3N') INFO  [redis-swarm-worker] Spinning up worker for Resource ${QUEUE_NAME}.\n";
    ckan -c /srv/app/ckan/registry/registry.ini jobs worker $QUEUE_NAME --max-idle-time $REDIS_WORKER_TIMEOUT > /dev/null 2>&1 &
    printf "$(date -u +'%Y-%m-%d %H:%M:%S,%3N') INFO  [redis-swarm-worker] Worker for Resource ${QUEUE_NAME} running on PID $!.\n";
  fi;
done < "${1:-/dev/stdin}"
