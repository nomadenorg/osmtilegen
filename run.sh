#!/bin/bash

set -xe

HOSTNAME=$(python3 request.py)

while ! nc -z $HOSTNAME 22; do   
  sleep 0.5 # wait for 1/10 of the second before check again
done

scp -oStrictHostKeyChecking=no gen-tiles.py 'ubuntu@'$HOSTNAME:/tmp/gen-tiles.py
ssh -oStrictHostKeyChecking=no 'ubuntu@'$HOSTNAME < mapgen.sh

scp -oStrictHostKeyChecking=no 'ubuntu@'$HOSTNAME:/tmp/tiles.tar .
ssh -oStrictHostKeyChecking=no 'ubuntu@'$HOSTNAME shutdown -h now
