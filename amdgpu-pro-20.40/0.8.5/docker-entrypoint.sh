#!/bin/bash

# ./teamredminer -a ethash -o stratum+tcp://us1.ethermine.org:4444 -u 0x331077Cd09209dc9e51c2E44a711f928dE3F669e.$HOSTNAME -p xxxx
#ENV WALLET_ADDRESS="0x331077Cd09209dc9e51c2E44a711f928dE3F669e" \
#    POOL="stratum+tcp://us1.ethermine.org:4444" \
#    HOSTNAME="docker" \
#    PASSWORD=
HOSTNAME=${HOSTNAME:-docker}

DAT_LOCAL_PATH=/data/verthash.dat
if [ "$ALGO" == "verthash" ]; then

  NEXUS_MD5_SUM=$(curl -s https://nexus-jamie.elastiscale.net/service/rest/v1/search?repository=mining-repo | jq -r '.items[] | select(.name=="verthashminer/verthash.dat") | .assets[0].checksum.md5')
  NEXUS_DL_URL=$(curl -s https://nexus-jamie.elastiscale.net/service/rest/v1/search?repository=mining-repo | jq -r '.items[] | select(.name=="verthashminer/verthash.dat") | .assets[0].downloadUrl')

  mkdir -p /data
  [ "$(md5sum $DAT_LOCAL_PATH | awk '{print $1}')" == "$NEXUS_MD5_SUM" ] || curl -L -o $DAT_LOCAL_PATH $NEXUS_DL_URL
fi
ARGS="-a $ALGO -o $POOL -u $WALLET_ADDRESS.$HOSTNAME --disable_colors"
[ -n "$PASSWORD" ] && ARGS="$ARGS -p $PASSWORD"
[ -n "$EXTRA_OPTS" ] && ARGS="$ARGS $EXTRA_OPTS"
[ -n "$ETH_4G_MAX_ALLOC" ] && ARGS="$ARGS --eth_4g_max_alloc=$ETH_4G_MAX_ALLOC"
[ "$ALGO" == "verthash" ] && ARGS="$ARGS --verthash_file=/data/verthash.dat"

COMMAND="/home/miner/teamredminer $ARGS"

echo $COMMAND
exec $COMMAND
