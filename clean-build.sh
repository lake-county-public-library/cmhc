#!/bin/bash

# Clean up
rm -v _cmhc/*
rm -v _directories/*
rm -v _census/*
rm -v _life/*
rm -v search/*

if [ -z _site ]; then
  mv _site .trash
  rm -rf .trash &
fi

date
#bundle exec rake wax:derivatives:iiif cmhc
#bundle exec rake wax:derivatives:iiif directories
#bundle exec rake wax:derivatives:iiif census
#bundle exec rake wax:derivatives:iiif life
bundle exec rake wax:pages cmhc
bundle exec rake wax:pages directories
bundle exec rake wax:pages census
bundle exec rake wax:pages life
bundle exec rake wax:search main
bundle exec rake wax:search directories
bundle exec rake wax:search census
bundle exec rake wax:search life

#read -p "continue with 'clean' when ready..." -n 1
date; time bundle exec jekyll clean

#read -p "continue with 'build' when ready..." -n 1
date; time JEKYLL_ENV=production bundle exec jekyll build > misc/build.out 2>&1
#date; time JEKYLL_ENV=production bundle exec jekyll build --profile > misc/build.out 2>&1

# echo "gzip -v9 search/directories.json"
# gzip -v9 search/directories.json
# mv search/directories.json.gz search/directories.json
date

## Real run, no delete: use when all changes are additive (most common scenario)
#date; time aws s3 sync _site/ s3://history.lakecountypubliclibrary.org/cmhc/ --exclude clean-build.sh --exclude notes.txt --exclude s3_website.yml --exclude 'misc/*' --size-only --profile lcpl

## Real run, with delete
#date; time aws s3 sync _site/ s3://history.lakecountypubliclibrary.org/cmhc/ --delete --exclude clean-build.sh --exclude notes.txt --exclude s3_website.yml --exclude 'misc/*' --size-only --profile lcpl

###
# Dryrun commands
###
## Dryrun, no delete: use when all changes are additive
date; time aws s3 sync --dryrun _site/ s3://history.lakecountypubliclibrary.org/cmhc/ --exclude clean-build.sh --exclude notes.txt --exclude s3_website.yml --exclude 'misc/*' --size-only --profile lcpl

## Dryrun, with delete
#date; time aws s3 sync --dryrun _site/ s3://history.lakecountypubliclibrary.org/cmhc/ --delete --exclude clean-build.sh --exclude notes.txt --exclude s3_website.yml --exclude 'misc/*' --size-only --profile lcpl
###


## Retain complete 'img/' 
# rsync --dry-run --size-only -avz img/ misc/img-src/ | tee misc/rsync.out

#bundle exec jekyll serve
#bundle exec jekyll serve --no-watch
