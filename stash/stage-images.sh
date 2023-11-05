#!/bin/bash


###
# This script find all of the PIDs from each of the metadata spreadsheets in
#  the 'stash' directory, and copies each of their iiif derivatives from the
#  sibling '../cmhc/' project.
###

BASE_DIR=/home/awoods/programming/www/leadville-library
SMALL_DIR="${BASE_DIR}/small-cmhc"
CMHC_DIR="${BASE_DIR}/cmhc"
STASH_DIR="${SMALL_DIR}/stash"
SCRIPTS_DIR="${BASE_DIR}/tmp-staging"

# Clean out existing images
#rm -rf ${SMALL_DIR}/img/derivatives/iiif

i=0

# Re-stage selected images
for x in `cat pids.txt`; do
  echo "$i: stage.. $x"
  if ! [ -f $SMALL_DIR/img/derivatives/iiif/canvas/$x.json ]; then
    echo ">>>>> copying.. $x"
    bash ${SCRIPTS_DIR}/copy.sh $x
  fi
  i=$(( i+1 ))
done

# Create csv header for new sheets
for c in cmhc.csv directories.csv census.csv; do
  grep "pid,label" $c > "small-$c" 
done

# Include rows for selected pids in sheets
for x in `cat pids.txt`; do
  if [[ $x == *pl || $x == *cc ]]; then
    echo "$i: $x : cmhc"
    grep $x cmhc.csv >> "small-cmhc.csv"
  elif [[ $x == *cd ]]; then
    echo "$i: $x : directory"
    grep $x directories.csv >> "small-directories.csv"
  elif [[ $x == *ci ]]; then
    echo "$i: $x : census"
    grep $x census.csv >> "small-census.csv"
  else
    echo "$i: $x : ERROR"
  fi
  i=$(( i+1 ))
done
