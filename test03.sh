#!/bin/bash

# This is a test case that checks:
# rm scenarios 2

# Remove .legit if it already exists
rm -rf .legit &> /dev/null;
# create init : Should Work
perl legit.pl init;
# No commits have been made
echo hello world > a;
perl legit.pl rm a;
# Commits have been made
perl legit.pl add a;
perl legit.pl commit -m "First commit";
# File in WD != File in commit == File in index
echo changed file > a;
perl legit.pl rm a;
perl legit.pl show :a;
# File in WD = File in Index != file in commit
perl legit.pl add a;
perl legit.pl rm a;
cat a;
# File in WD == File in Commit != File in Index
perl legit.pl commit -m "Second Commit";
echo hello world > a;
perl legit.pl add a;
echo changed file > a;
perl legit.pl rm a;
cat a;
perl legit.pl show :a;