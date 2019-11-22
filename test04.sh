#!/bin/bash

# This is a test case that checks:
# rm scenarios 3

# Check cached and force flags

# Remove .legit if it already exists
rm -rf .legit &> /dev/null;
# create init : Should Work
perl legit.pl init;
# cached
touch a b;
perl legit.pl add a b;
perl legit.pl commit -m "Added a b";
perl legit.pl rm --cached a b;
perl legit.pl commit -m "removed a b from index";
perl legit.pl show :a;
perl legit.pl show :b;
perl legit.pl show 1:a;
perl legit.pl show 1:b;
cat a;
cat b;
# force
touch c d;
perl legit.pl add c d;
perl legit.pl commit -m "Added c d";
echo hello > c;
echo hello > d;
perl legit.pl add c d;
rm c d;
touch c d;
perl legit.pl rm --force c d;
perl legit.pl commit -m "force removed c d";
perl legit.pl show :c;
perl legit.pl show :d;
perl legit.pl show 1:c;
perl legit.pl show 1:d;
perl legit.pl show 0:c;
perl legit.pl show 0:d;
cat c;
cat d;
# force cached
touch e f;
perl legit.pl add e f;
perl legit.pl commit -m "Added e f";
echo hello > e;
echo hello > f;
perl legit.pl add e f;
perl legit.pl rm --force --cached e f;
perl legit.pl commit -m "force removed e f from the index";
perl legit.pl show :e;
perl legit.pl show :f;
perl legit.pl show 1:e;
perl legit.pl show 1:f;
perl legit.pl show 0:e;
perl legit.pl show 0:f;
cat e;
cat f;
# cached force - order of flags switched
touch g h;
perl legit.pl add g h;
perl legit.pl commit -m "Added g h";
echo hello > g;
echo hello > h;
perl legit.pl add g h;
perl legit.pl rm --cached --force g h;
perl legit.pl commit -m "force removed g h from the index";
perl legit.pl show :g;
perl legit.pl show :h;
perl legit.pl show 1:g;
perl legit.pl show 1:h;
perl legit.pl show 0:g;
perl legit.pl show 0:h;
cat g;
cat h;