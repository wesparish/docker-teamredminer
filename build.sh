#!/bin/bash

registry=${1:-wesparish}
imagename=teamredminer
imagename=${2:-$imagename}

privateRegistry=${3:-nexus-jamie-docker.elastiscale.net}

for dockerfile in $(find  -name Dockerfile); do
  versionvariant=$(dirname $dockerfile | sed -e 's|^./||g' -e 's|/|-|g')
  echo Building variant: $versionvariant
  echo docker build -t $registry/${imagename}:${versionvariant} $(dirname $dockerfile)
  docker build -t $registry/${imagename}:$versionvariant $(dirname $dockerfile)
  echo docker push $registry/${imagename}:${versionvariant}
  docker push $registry/${imagename}:$versionvariant

  echo docker tag $registry/${imagename}:${versionvariant} ${privateRegistry}/${imagename}:${versionvariant}
  docker tag $registry/${imagename}:$versionvariant ${privateRegistry}/${imagename}:$versionvariant
  echo docker push ${privateRegistry}/${imagename}:${versionvariant}
  docker push ${privateRegistry}/${imagename}:$versionvariant
done
