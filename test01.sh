#!/bin/bash

# This is a test case that checks:
# if .legit exists before running any command
# re-creating .legit.

# Remove .legit if it already exists
rm -rf .legit &> /dev/null;
# Check .legit for commands other than init, all should throw error
perl legit.pl add a;
perl legit.pl commit -m "Try committting without .legit";
perl legit.pl rm a;
perl legit.pl log;
perl legit.pl show 0:a;
perl legit.pl status;
perl legit.pl branch newBranch;
# create init : Should Work
perl legit.pl init;
# re-create init : Should throw error
perl legit.pl init;
