#!/bin/bash

rm -v _cmhc/*
rm -v _directories/*
rm -v search/*


#bundle exec rake wax:derivatives:iiif cmhc
#bundle exec rake wax:derivatives:iiif directories
bundle exec rake wax:pages cmhc
bundle exec rake wax:pages directories
bundle exec rake wax:search main
bundle exec rake wax:search directories

#read -p "continue with 'clean' when ready..." -n 1
bundle exec jekyll clean

#read -p "continue with 'build' when ready..." -n 1

date; time JEKYLL_ENV=production bundle exec jekyll build

#date; time aws s3 sync _site/ s3://history.lakecountypubliclibrary.org/cmhc/ --delete --exclude clean-build.sh --exclude notes.txt --exclude s3_website.yml --size-only --profile lcpl

#bundle exec jekyll serve
#bundle exec jekyll serve --no-watch
