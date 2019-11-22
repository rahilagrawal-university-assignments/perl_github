#!/bin/bash

# This is a test case that checks:
# branches - merge

# Remove .legit if it already exists
rm -rf .legit &> /dev/null;
# create init : Should Work
perl legit.pl init;
# create new branch
perl legit.pl branch b1;
perl legit.pl checkout b1;
echo hello world > a;
perl legit.pl add a;
perl legit.pl commit -m "First commit";
# create new branch
perl legit.pl branch b2;
perl legit.pl checkout b2;
echo hello world > b;
echo merge conflict > a;
perl legit.pl add a b;
perl legit.pl commit -m "This commit will create a merge conflict!";
perl legit.pl merge b1;
# Should work now
perl legit.pl rm b;
perl legit.pl rm a;
perl legit.pl commit -m "Removed the files";
perl legit.pl merge b1;