#!/bin/bash

if [[ $1 != -h*=* ]] && [[ $1 != -e*=* ]]; then
    echo "USAGE: " \
        " createShardableMongo --hostcount=<count> --environment=<DOCKER|AWS>"
        exit 1
fi

if [[ $2 != -h*=* ]] && [[ $2 != -e*=* ]]; then
    echo "USAGE: " \
        " createShardableMongo --hostcount=<count> --environment=<DOCKER|AWS>"
        exit 1
fi
HOSTCOUNT=
ENV_TYP=
if [[ $1 == -h* ]]; then
    HOSTCOUNT=`awk '{split($0,a,"="); print a[2]}' <<< $1`
    ENV_TYP=`awk '{split($0,a,"="); print a[2]}' <<< $2`
elif [[ $2 == -h* ]]; then
    HOSTCOUNT=`awk '{split($0,a,"="); print a[2]}' <<< $2`
    ENV_TYP=`awk '{split($0,a,"="); print a[2]}' <<< $1`
fi

if [[ $ENV_TYP != "DOCKER" ]] && [[ $ENV_TYP != "AWS" ]]; then
    echo "Available Environment Types: DOCKER or AWS ($ENV_TYP)"
    echo "USAGE: " \
        " createShardableMongo --hostcount=<count> --environment=<DOCKER|AWS>"
    exit 1
fi

re='^[0-9]+$'
if ! [[ $HOSTCOUNT =~ $re ]] ; then
   echo "Error: --hostcount must be a number ($HOSTCOUNT)" >&2; exit 1
fi

if [[ $ENV_TYP == "DOCKER" ]]; then
    echo "Building: "$HOSTCOUNT"s hosts on " $ENV_TYP-MACHINE
    COUNTER=1
    for i in `docker-machine ls | awk '{split($0,a," "); print a[1]}' | grep -v NAME`
    do 
        if [[ $i == mongo* ]]; then
            echo "re-using existing mongo host"
            # remove them in a 'producton setting'
            # docker-machine rm -f $i
            let COUNTER+=1
        fi
    done
    if [[ $COUNTER -le $HOSTCOUNT ]]; then
        for i in `seq $COUNTER $HOSTCOUNT`;
        do
            echo "Creating docker-machine: mongo$i"
            docker-machine create --driver virtualbox mongo$i
        done   
    fi
    
    docker-machine ls
elfi [[ $ENV_TYP == "AWS" ]]; then
    echo "Starting AMI with user-data scripts"
fi

