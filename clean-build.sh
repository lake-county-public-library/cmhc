#!/bin/bash

# Clean up
rm -v _cmhc/*
rm -v _directories/*
rm -v _census/*
rm -v search/*

if [ -z _site ]; then
  mv _site .trash
  rm -rf .trash &
fi

#bundle exec rake wax:derivatives:iiif cmhc
#bundle exec rake wax:derivatives:iiif directories
#bundle exec rake wax:derivatives:iiif census
bundle exec rake wax:pages cmhc
bundle exec rake wax:pages directories
bundle exec rake wax:pages census
bundle exec rake wax:search main
bundle exec rake wax:search directories
bundle exec rake wax:search census

#read -p "continue with 'clean' when ready..." -n 1
date; time bundle exec jekyll clean

#read -p "continue with 'build' when ready..." -n 1
date; time JEKYLL_ENV=production bundle exec jekyll build --profile > misc/build.out 2>&1

#date; time aws s3 sync _site/ s3://history.lakecountypubliclibrary.org/cmhc/ --delete --exclude clean-build.sh --exclude notes.txt --exclude s3_website.yml --exclude misc --size-only --profile lcpl
#date; time aws s3 sync --dryrun _site/ s3://history.lakecountypubliclibrary.org/cmhc/ --delete --exclude clean-build.sh --exclude notes.txt --exclude s3_website.yml --exclude misc --size-only --profile lcpl

#bundle exec jekyll serve
#bundle exec jekyll serve --no-watch
