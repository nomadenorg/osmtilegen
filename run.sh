#!/bin/bash

set -xe

echo "Requesting spot instance..."

HOSTNAME=$(python3 request.py)

while ! nc -z $HOSTNAME 22; do   
  sleep 0.5 # wait for 1/10 of the second before check again
done

scp -oStrictHostKeyChecking=no gen-tiles.py 'ubuntu@'$HOSTNAME:/tmp/gen-tiles.py

scp -oStrictHostKeyChecking=no mapgen.sh 'ubuntu@'$HOSTNAME:/home/ubuntu

echo "Generating maps..."

ssh -oStrictHostKeyChecking=no -oServerAliveInterval=100 'ubuntu@'$HOSTNAME bash /home/ubuntu/mapgen.sh

echo "Copying data to local disk..."

scp -oStrictHostKeyChecking=no 'ubuntu@'$HOSTNAME:/tmp/tiles.tar .

echo "Done. Shutting down remote host..."

ssh -oStrictHostKeyChecking=no 'ubuntu@'$HOSTNAME sudo shutdown -h now

echo "Map generation finished."
