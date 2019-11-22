#!/bin/bash

# This is a simple test case that checks:
# normal case for add, commit, log and status.

# Remove .legit if it already exists
rm -rf .legit &> /dev/null;
# init : should work
perl legit.pl init;
# check simple add : should work
perl legit.pl add diary.txt;
# check simple commit : should work
perl legit.pl commit -m "added diary.txt"; 
# check add without changing (should add but not commit) : should work
perl legit.pl add diary.txt;
# check duplicate commit : should throw error
perl legit.pl commit -m "retry adding same diary.txt";
# check another add : should work
perl legit.pl add clean.sh;
# check new commit : should work
perl legit.pl commit -m "Added clean.sh";
# check log : should work
perl legit.pl log;
# check status : should work
perl legit.pl status;