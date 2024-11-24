#!/usr/bin/env bash
source ./config.sh

curl -L -o factorio.tar.xz "https://www.factorio.com/get-download/$FACTORIO_VERSION/headless/linux64"
mkdir /tmp/factorio
tar -xf factorio.tar.xz -C /tmp/factorio
rm factorio.tar.xz


cp -r /tmp/factorio/factorio/* ./
rm -r /tmp/factorio/

mkdir -p ./saves/
