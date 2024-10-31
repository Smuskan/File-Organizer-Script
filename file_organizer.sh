#!/bin/bash

# Function to create subdirectories based on file types
create_directories() {
  mkdir -p "$1/Images"
  mkdir -p "$1/Documents"
  mkdir -p "$1/Videos"
  mkdir -p "$1/Audio"
}

# Function to log organized files
log_files() {
  echo "$(date): Organized the following files:" >> "$1"
  for file in "$2"/*; do
    echo "$file" >> "$1"
  done
}

# Ensure the correct number of arguments are passed (1 argument required)
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <directory_to_organize>"
  exit 1
fi

# Assign the directory to organize from arguments
dirToOrganize="$1"

# Verify that the argument is a valid directory
if [[ ! -d "$dirToOrganize" ]]; then
  echo "Error: The provided path is not a valid directory."
  exit 1
fi

# Create a backup of the original files
backupDir="$dirToOrganize/backup-$(date +%s)"
mkdir -p "$backupDir"
cp -r "$dirToOrganize/"* "$backupDir"

# Create subdirectories for organization
create_directories "$dirToOrganize"

# Create a log file
logFile="$dirToOrganize/organize_log_$(date +%Y%m%d_%H%M%S).txt"

# Organize files into respective directories based on their extension
for file in "$dirToOrganize"/*; do
  if [[ -f "$file" ]]; then
    case "${file##*.}" in
      jpg|jpeg|png|gif)
        mv "$file" "$dirToOrganize/Images/"
        ;;
      pdf|doc|docx|txt)
        mv "$file" "$dirToOrganize/Documents/"
        ;;
      mp4|avi|mkv)
        mv "$file" "$dirToOrganize/Videos/"
        ;;
      mp3|wav|flac)
        mv "$file" "$dirToOrganize/Audio/"
        ;;
      *)
        echo "Unknown file type: $file"
        ;;
    esac
  fi
done

# Log the organized files
log_files "$logFile" "$dirToOrganize"

echo "Organization complete! Backup created at: $backupDir"
echo "Log file created at: $logFile"
