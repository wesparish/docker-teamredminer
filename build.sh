#!/bin/bash

usage() { echo "Usage: $0 [-p (disable push)] " \
               "[-q <dont push to default registry> (default: push to default registry)] " \
               "[-r <registry> (default: wesparish)] " \
               "[-i <image name> (default: $(basename $PWD))] " \
               "[-a <additional private registry> (default: none)]" 1>&2; exit 1; }

# Defaults
push=true
pushDefaultRegistry=true
registry="wesparish"
imagename="$(basename $PWD)"
privateRegistry=
echo "Args: push: $push, registry: $registry, imagename: $imagename, privateRegistry: $privateRegistry"

while getopts ":pqr:i:a:" o; do
    case "${o}" in
        p)
            push=
            ;;
        q)
            pushDefaultRegistry=
            ;;
        r)
            registry=${OPTARG}
            ;;
        i)
            imagename=${OPTARG}
            ;;
        a)
            privateRegistry=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

echo "Args: push: $push, pushDefaultRegistry: $pushDefaultRegistry, registry: $registry, \
 imagename: $imagename, privateRegistry: $privateRegistry"

buildDate=$(date +%Y-%m-%d-%H%M%S)

set -e

for dockerfile in $(find  -name Dockerfile); do
  versionvariant=$(dirname $dockerfile | sed -e 's|^./||g' -e 's|/|-|g')
  echo Building variant: $versionvariant
  echo docker build -t $registry/${imagename}:${versionvariant} $(dirname $dockerfile)
  docker build -t $registry/${imagename}:$versionvariant $(dirname $dockerfile)
  echo docker push $registry/${imagename}:${versionvariant}
  [ $push ] && [ $pushDefaultRegistry ] && docker push $registry/${imagename}:$versionvariant

  docker tag $registry/${imagename}:${versionvariant} $registry/${imagename}:${versionvariant}-${buildDate}
  echo docker push $registry/${imagename}:${versionvariant}-${buildDate}
  [ $push ] && [ $pushDefaultRegistry ] && docker push $registry/${imagename}:${versionvariant}-${buildDate}

  if [ -n "$privateRegistry" ] ; then
    echo docker tag $registry/${imagename}:${versionvariant} ${privateRegistry}/${imagename}:${versionvariant}
    docker tag $registry/${imagename}:$versionvariant ${privateRegistry}/${imagename}:$versionvariant
    echo docker push ${privateRegistry}/${imagename}:${versionvariant}
    [ $push ] && docker push ${privateRegistry}/${imagename}:$versionvariant

    echo docker tag $registry/${imagename}:${versionvariant} ${privateRegistry}/${imagename}:${versionvariant}-${buildDate}
    docker tag $registry/${imagename}:${versionvariant} ${privateRegistry}/${imagename}:${versionvariant}-${buildDate}
    echo docker push ${privateRegistry}/${imagename}:${versionvariant}-${buildDate}
    [ $push ] && docker push ${privateRegistry}/${imagename}:${versionvariant}-${buildDate}
  fi
done

set +e
