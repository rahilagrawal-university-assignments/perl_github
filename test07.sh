#!/bin/bash

# This is a test case that checks:
# branches - create, delete and error messages

# Remove .legit if it already exists
rm -rf .legit &> /dev/null;
# create init : Should Work
perl legit.pl init;
# check branch name without commits
perl legit.pl branch;
# create a commit
touch a;
perl legit.pl add a;
perl legit.pl commit -m "First Commit";
# Check branch now
perl legit.pl branch;
# create a new branch
perl legit.pl branch newBranch;
perl legit.pl branch;
# try double create
perl legit.pl branch newBranch;
# delete branch
perl legit.pl branch -d newBranch;
# delete branch that does not exist
perl legit.pl branch -d newBranch;
# try to delete master
perl legit.pl branch -d master;
