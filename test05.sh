
#!/bin/bash

# This is a test case that checks:
# status 1
# in WD

# Remove .legit if it already exists
rm -rf .legit &> /dev/null;
# create init : Should Work
perl legit.pl init;
touch a b c d e;
touch 5;
perl legit.pl add 5;
perl legit.pl commit -m "zero commit";
# not in commit and not in index - a
perl legit.pl status;
# not in commit but in index
    # same - b
perl legit.pl add b;
perl legit.pl status;
    # different - c
perl legit.pl add c;
echo hello > c;
perl legit.pl status;
# in commit but not in index
    # same - d
perl legit.pl add d;
perl legit.pl commit -m "First Commit";
perl legit.pl rm --cached d;
perl legit.pl status;
    # different - e
perl legit.pl add e;
perl legit.pl commit -m "Second Commit";
perl legit.pl rm --cached e;
echo hello > e;
perl legit.pl status;
# in commit and in index
    # same all throught
touch f;
perl legit.pl add f;
perl legit.pl commit -m "Third Commit";
perl status;
    # different all throughout
touch g;
perl legit.pl add g;
perl legit.pl commit -m "Fpurth Commit";
echo hello > g;
perl legit.pl add g;
echo world > g;
perl status;
    # wd == commit != index
touch h;
perl legit.pl add h;
perl legit.pl commit -m "Fourth Commit";
echo hello > h;
perl legit.pl add h;
rm h;
touch h;
perl status;
    # wd == index != commit
touch 1;
perl legit.pl add 1;
perl legit.pl commit -m "Fifth Commit";
echo hello > 1;
perl legit.pl add 1;
perl status;
    # commit == index != wd	- d
touch 2;
perl legit.pl add 2;
perl legit.pl commit -m "Sixth Commit";
echo hello > 1;
perl status;