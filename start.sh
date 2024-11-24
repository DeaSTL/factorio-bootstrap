#!/usr/bin/env bash
source ./config.sh

set -x;

DEFAULT_SAVE_NAME=save.zip
SAVE_DIR=./saves
SAVE_FILE=$(find $SAVE_DIR -name "*.zip" | xargs)
SETTINGS_FILE=$(ls -h "server-settings.json" | xargs)
FACTORIO=./bin/x64/factorio

echo "$SAVE_FILE"
if [ "$SAVE_FILE" = "" ]; then
  $FACTORIO  --create "$SAVE_DIR/$DEFAULT_SAVE_NAME"
fi

if [ "$SETTINGS_FILE" = "" ]; then
  cp ./data/server-settings.example.json ./server-settings.json
fi


function start() 
{
  $FACTORIO --start-server-load-latest --server-settings ./server-settings.json --bind $SERVER_HOST:$SERVER_PORT
}

#Catching the the Ctrl+C
trap exit 1 INT

if [ "$BACKUP_ENABLED" = "1" ];then
  echo "Backups enabled"
  ./backup.sh &
fi


while [[ 1=1 ]]; do
  start
  echo "restarting in 5 seconds..."
  sleep 5
done


