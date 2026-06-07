#!/bin/bash

DATASET="iron-wolf/media/documents"
MOUNTPOINT=$(zfs get -H -o value mountpoint "$DATASET")

if [ "$KEYSTATUS" = "available" ]; then
  if ! mountpoint -q "$MOUNTPOINT"; then
    sudo zfs mount "$DATASET" || { zenity --error --text="Failed to mount dataset."; exit 1; }
  fi
else
  # Key is unavailable. Prompt for it.
  PASS=$(zenity --password --title="Unlock ZFS Volume" --window-icon="lock")

  # If user hits cancel or leaves it empty, exit quietly
  if [ -z "$PASS" ]; then
    exit 0
  fi

  # Try to load key and mount
  if echo "$PASS" | sudo zfs load-key "$DATASET"; then
    sudo zfs mount "$DATASET" || { zenity --error --text="Key loaded, but mount failed."; exit 1; }
  else
    zenity --error --text="Incorrect passphrase."
    exit 1
  fi
fi

if command -v kioclient &> /dev/null; then
  kioclient exec "$MOUNTPOINT"
else
  xdg-open "$MOUNTPOINT"
fi;
