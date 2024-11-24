#!/usr/bin/env bash
source ./config.sh

mkdir -p $BACKUP_LOCATION

function timestamp ()
{
  echo $(date +"%D_%T" | sed 's/\//-/g;s/:/-/g')
}

FILES_TO_BACKUP=(./player-data.json ./data/ ./achievements.dat ./mods/ ./saves/ ./temp/ ./server-settings.json ./config-path.cfg)

WORKING_DIR=$(pwd)

while [[ 1=1 ]]; do
  sleep $BACKUP_INTERVAL
  echo "Backing up...."
  CURRENT_BACKUPS=($(ls -th ./$BACKUP_LOCATION/))
  TIME_STAMP=$(timestamp)
  TMP_DIR=/tmp/factorio-backup-$SERVER_ID-$TIME_STAMP

  mkdir -p $TMP_DIR

  for FILE in "${FILES_TO_BACKUP[@]}"
  do
    cp -r $FILE $TMP_DIR/
  done
  BACKUP_ARCHIVE="$WORKING_DIR/$BACKUP_LOCATION/$SERVER_ID-$TIME_STAMP.tar.gz"

  cd $TMP_DIR && tar -czf "$BACKUP_ARCHIVE" ./
  cd -

  BACKUP_SIZE=$(du -h $BACKUP_ARCHIVE)
  BACKUP_SIZE_TOTAL=$(du -h $BACKUP_LOCATION)

  echo "backup size: $BACKUP_SIZE"
  echo "total backup size: $BACKUP_SIZE_TOTAL"

  echo "Checking old backups..."
  
  BACKUP_COUNT=0
  for BACKUP in "${CURRENT_BACKUPS[@]}"
  do
    BACKUP_COUNT=$(($BACKUP_COUNT + 1))
    if (($BACKUP_COUNT > $BACKUP_LIMIT)); then
      echo "Deleting old archive $BACKUP" 
      rm "$WORKING_DIR/$BACKUP_LOCATION/$BACKUP"
    fi
    echo "$BACKUP_COUNT"
    echo "$BACKUP"
  done
  
  rm -r $TMP_DIR
done





