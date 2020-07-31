#!/usr/bin/env bash
#set -eo pipefail

EPOOLS="/home/claymore/epools.txt"

#HOSTNAME=$(curl -s rancher-metadata/latest/self/host/name | cut -d'.' -f1)
HOSTNAME=${NODE_NAME:-localhost}

[ -f $EPOOLS ] && rm $EPOOLS || true

CARDS=`nvidia-smi --query-gpu=memory.used,index,gpu_uuid --format=csv,noheader,nounits | tr -d ' '`

# will select first one
for CARD in $CARDS
do
	USAGE=`echo $CARD | cut -d, -f1`
	ID=`echo $CARD | cut -d, -f2`
	UUID=`echo $CARD | cut -d, -f3`
	SHORT_UUID=`echo $UUID | cut -d- -f6`
	echo ">>> card $UUID selected"
	for HOST in $HOSTS
	do
		POOL=`echo $HOST | cut -d: -f1,2`
		PSW=`echo $HOST | cut -d: -f3`
		ESM=`echo $HOST | cut -d: -f4`
		ALLPOOLS=`echo $HOST | cut -d: -f5`
		echo "POOL: ${POOL}, WALLET: ${WALLET_ADDRESS}.${HOSTNAME}, PSW: ${PSW}, ESM: ${ESM}, ALLPOOLS: ${ALLPOOLS}" >> $EPOOLS
	done

	exec /home/claymore/ethdcrminer64 $CLAYMORE_OPTS $@
done

echo "no card available waiting 30s ..."
sleep 30
