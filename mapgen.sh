#!/bin/bash

set -xe

# Install PostgreSQL

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'
sudo apt-get update
sudo apt-get -y install postgresql-10 postgresql-10-postgis-2.5  unzip

sudo -u postgres createuser gisuser

sudo -u postgres createdb --encoding=UTF8 --owner=gisuser gis

sudo -u postgres psql --username=postgres --dbname=gis -c "CREATE EXTENSION postgis;"

sudo -u postgres psql --username=postgres --dbname=gis -c "CREATE EXTENSION postgis_topology;"

sudo -u postgres psql --username=postgres --dbname=gis -c "CREATE EXTENSION hstore;"

sudo apt-get -y install osm2pgsql

# get the latest Hamburg extract for OSM

cd /tmp

#wget https://planet.openstreetmap.org/planet/planet-latest.osm.bz2
wget https://download.geofabrik.de/europe/germany/hamburg-latest.osm.bz2

bzip2 -d hamburg-latest.osm.bz2

wget https://svn.openstreetmap.org/applications/rendering/mapnik/generate_image.py

wget https://svn.openstreetmap.org/applications/rendering/mapnik/generate_tiles.py

# INSTALL carto

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

sudo apt-get install -y nodejs

sudo npm -g install carto

git clone https://github.com/gravitystorm/openstreetmap-carto

cd openstreetmap-carto

carto project.mml >osm.xml

# INSTALL mapnik

cd /tmp

sudo add-apt-repository -y ppa:no1wantdthisname/ppa

sudo apt-get update

sudo add-apt-repository -y ppa:talaj/osm-mapnik

sudo apt-get update

sudo apt-get install -y libboost-all-dev libmapnik-dev python-mapnik

# INSTALL fonts

sudo apt-get install -y ttf-unifont fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted

cd /tmp

mkdir noto

cd noto

# Grab some extra noto fonts from Google

wget https://noto-website-2.storage.googleapis.com/pkgs/Noto-hinted.zip

unzip Noto-hinted.zip

sudo cp /tmp/noto/*.otf /usr/share/fonts/opentype/noto/

sudo cp /tmp/noto/*.ttf /usr/share/fonts/truetype/noto

fc-cache

# Generate tiles

cd /tmp/openstreetmap-carto

sudo apt-get install -y mapnik-utils

./scripts/get-shapefiles.py

sudo su - postgres -c "cd /tmp/openstreetmap-carto; osm2pgsql -G --hstore --style openstreetmap-carto.style --tag-transform-script openstreetmap-carto.lua -d gis ../hamburg-latest.osm" 

sudo -u postgres mkdir -p /tmp/tiles

sudo -u postgres python ../gen-tiles.py

# tar it all up for downloading

cd /tmp

tar cf tiles.tar tiles
