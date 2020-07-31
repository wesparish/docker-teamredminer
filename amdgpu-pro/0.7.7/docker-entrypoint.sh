#!/bin/bash

# ./teamredminer -a ethash -o stratum+tcp://us1.ethermine.org:4444 -u 0x331077Cd09209dc9e51c2E44a711f928dE3F669e.$HOSTNAME -p xxxx
#ENV WALLET_ADDRESS="0x331077Cd09209dc9e51c2E44a711f928dE3F669e" \
#    POOL="stratum+tcp://us1.ethermine.org:4444" \
#    HOSTNAME="docker" \
#    PASSWORD=
HOSTNAME=${HOSTNAME:-docker}

ARGS="$EXTRA_OPTS -a ethash -o $POOL -u $WALLET_ADDRESS.$HOSTNAME"
[ -n "$PASSWORD" ] && ARGS="$ARGS -p $PASSWORD"
[ -n "$EXTRA_OPTS" ] && ARGS="$ARGS $EXTRA_OPTS"

COMMAND="/home/miner/teamredminer $ARGS"

echo $COMMAND
exec $COMMAND
