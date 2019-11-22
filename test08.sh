#!/bin/bash

# This is a test case that checks:
# branches - checkout

# Remove .legit if it already exists
rm -rf .legit &> /dev/null;
# create init : Should Work
perl legit.pl init;
# checkout to non existent branch
perl legit.pl checkout b1;
# create new branch
perl legit.pl branch b1;
# checkout to new branch
perl legit.pl checkout b1;
# add something to index
echo hello world > a;
perl legit.pl add a;
# create new branch
perl legit.pl branch b2;
# checkout to new branch
perl legit.pl checkout b2;