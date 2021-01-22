#!/bin/bash

registry=${1:-wesparish}
imagename=teamredminer
imagename=${2:-$imagename}

privateRegistry=${3:-nexus-jamie-docker.elastiscale.net}

buildDate=$(date +%Y-%m-%d-%H%M%S)

for dockerfile in $(find  -name Dockerfile); do
  versionvariant=$(dirname $dockerfile | sed -e 's|^./||g' -e 's|/|-|g')
  echo Building variant: $versionvariant
  echo docker build -t $registry/${imagename}:${versionvariant} $(dirname $dockerfile)
  docker build -t $registry/${imagename}:$versionvariant $(dirname $dockerfile)
  echo docker push $registry/${imagename}:${versionvariant}
  docker push $registry/${imagename}:$versionvariant

  docker tag $registry/${imagename}:${versionvariant} $registry/${imagename}:${versionvariant}-${buildDate}
  echo docker push $registry/${imagename}:${versionvariant}-${buildDate}
  docker push $registry/${imagename}:${versionvariant}-${buildDate}

  if [ -n "$privateRegistry" ] ; then
    echo docker tag $registry/${imagename}:${versionvariant} ${privateRegistry}/${imagename}:${versionvariant}
    docker tag $registry/${imagename}:$versionvariant ${privateRegistry}/${imagename}:$versionvariant
    echo docker push ${privateRegistry}/${imagename}:${versionvariant}
    docker push ${privateRegistry}/${imagename}:$versionvariant

    docker tag $registry/${imagename}:${versionvariant} $registry/${imagename}:${versionvariant}-${buildDate}
    echo docker push $registry/${imagename}:${versionvariant}-${buildDate}
    docker push $registry/${imagename}:${versionvariant}-${buildDate}
  fi
done
