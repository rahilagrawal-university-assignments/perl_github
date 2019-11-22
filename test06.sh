#!/bin/bash

# This is a test case that checks:
# status 2
# not in WD

# Remove .legit if it already exists
rm -rf .legit &> /dev/null;
# create init : Should Work
perl legit.pl init;
touch a b c;
touch 5;
perl legit.pl add 5;
perl legit.pl commit -m "zero commit";
# in commit and in index - a
perl legit.pl add a;
perl legit.pl commit -m "first commit";
rm a;
perl legit.pl status;
# in commit and not in index - a
perl legit.pl rm --cached a;
perl legit.pl status;
# not in commit not in index- a
perl legit.pl commit -m "Second commit";
perl legit.pl status;
# not in commit, in index
touch a;
perl legit.pl add a;
rm a;
perl status;