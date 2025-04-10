#!/bin/bash

# Path to the Windows file
WINDOWS_FILE="/mnt/c/Users/stebaka/.wezterm.lua"

# Check if the Windows file exists
if [ ! -f "$WINDOWS_FILE" ]; then
  echo "Windows file does not exist: $WINDOWS_FILE"
  exit 0
fi

# Path to the Linux file
LINUX_FILE="wezterm/.wezterm.lua"

# Get the modification times of the files
WINDOWS_TIME=$(stat -c %Y "$WINDOWS_FILE")
LINUX_TIME=$(stat -c %Y "$LINUX_FILE")

# Define a threshold for the time difference (in seconds)
THRESHOLD=2

# Check if the Windows file is newer than the Linux file
if [ "$WINDOWS_TIME" -gt "$LINUX_TIME" ] && [ $(($WINDOWS_TIME - $LINUX_TIME)) -gt $THRESHOLD ]; then
  cp --preserve=timestamps "$WINDOWS_FILE" "$LINUX_FILE"
  echo "Copied from Windows to Linux."
else
  echo "Files are up to date."
fi
