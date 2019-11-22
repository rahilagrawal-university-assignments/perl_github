#!/bin/bash

# This is a test case that checks:
# rm scenarios 1

# Remove .legit if it already exists
rm -rf .legit &> /dev/null;
# create init : Should Work
perl legit.pl init;
# rm and commit : should work
touch a;
perl legit.pl add a;
perl legit.pl commit -m "Added a";
perl legit.pl rm a;
perl legit.pl commit -m "removed a";
# File not added yet
echo '' > b; 
perl legit.pl rm b;
# Remove more than one files - normal.
touch c d e;
perl legit.pl add c d e;
perl legit.pl commit -m "Added c d e";
perl legit.pl rm c d e;
# Remove more than one files - With changes in one file.
touch f g h;
perl legit.pl add f g h;
perl legit.pl commit -m "Added f g h";
echo hello > g;
perl legit.pl rm f g h;