#!/bin/sh

set -e

log() {
    echo "$(date)| $1"
}

helptext() {
    cat << EOF
    usage: entrypoint [-t | --test]
                      [--net]
                      [--boot]
                      [--start]
                      [-h | --help]
                      [-e | --exit]
EOF
}

if [ "$1" = 'entrypoint' ]; then
  log "EXECUTING ENTRYPOINT"
  shift
  while [ "$1" != "" ]
  do
    case $1 in
      -t | --test ) log "RUNNING TESTS"
                    ./wait-for-it.sh -t 30 -h $DB_HOST -p $DB_PORT --strict -- echo "$DB_HOST:$DB_PORT open!"
                    npm run test
                    ;;
      --net )       log "CONTAINER IP ADDRESS:$(hostname -i)"
                    log "CONTAINER HOSTNAME:$(hostname)"
                    ;;
      --boot )      log "RUNNING TASK: BOOT"
                    ./wait-for-it.sh -t 30 -h $DB_HOST -p $DB_PORT --strict -- echo "$DB_HOST:$DB_PORT open!"
                    node ace migration:run --force
                    ;;
      --start )     log "RUNNING TASK: START"
                    ./wait-for-it.sh -t 30 -h $DB_HOST -p $DB_PORT --strict -- echo "$DB_HOST:$DB_PORT open!"
                    node server.js
                    ;;
      -h | --help ) helptext
                    exit
                    ;;
      -e | --exit ) log "EXITING ENTRYPOINT"
                    exit
                    ;;
      * )           helptext
                    exit 1
    esac
    shift
  done
  exit
fi

log "RUNNING COMMAND: $@"
exec "$@"
