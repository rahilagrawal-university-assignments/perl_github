#!/usr/bin/perl

# Created By : Rahil Agrawal - z5165505
# 2041 Assignment 1 - Legit

use File::Copy;
use File::Compare;

$cmd = shift;
chomp $cmd;

init() if($cmd eq 'init');
printError("no .legit directory containing legit repository exists") if(!(-e ".legit"));
add() if($cmd eq 'add');
gitLog() if($cmd eq "log");
commit() if ($cmd eq 'commit');
show() if ($cmd eq 'show');
rm() if ($cmd eq 'rm');
status() if ($cmd eq 'status');
branch() if ($cmd eq 'branch');

# This function initialises a repository with relevant folders and files.
sub init{
	printError(".legit already exists") if (-e ".legit");
	mkdir ".legit";
	die	"Failed to create .legit\n" if (!(-e ".legit"));
	print "Initialized empty legit repository in .legit\n";
	mkdir ".legit/.git";
	mkdir ".legit/index";
	mkdir ".legit/commits";
	mkdir ".legit/branches/";
	open F, '>', ".legit/latestCommit.txt";
	print F "0";
	close F;
	open F, '>', ".legit/log.txt";
	close F;
	open F, '>', ".legit/branches/master";
	print F "0";
	close F;
}

# This function adds changes to the staging area a.k.a Index. 
sub add {
	foreach my $file (@ARGV){
		if (!(-e $file)){
			printError("can not open '$file'") if (!(-e ".legit/index/$file"));
			unlink ".legit/index/$file";
			next;
		}
		copy("$file",".legit/index/") or die "Copy failed: $!" ;
	}
}

# This function commits the changes in Index to a new commit. If there is nothing to commit, appropraite error message will be displayed.
sub commit {
	(my @files = glob ".legit/index/*");

	# If -a flag is found, then update the files in Index to their latest version from the working directory.
	if ($ARGV[0] eq "-a" && shift @ARGV){
		for my $file (@files){
			$originalFile = $file;
			$file =~ s|.legit/index/(.*)|$1|;
			if(!(-e $file)){
				unlink $originalFile;
				next;	
			}
		    copy("$file",".legit/index/") or die "Copy failed: $!" ;
		}
		@files = glob ".legit/index/*";
	}
	die "usage: legit.pl commit [-a] -m commit-message\n" if (!($ARGV[0] eq "-m"));

	# files in Index are the same as files in latest commit. 
	@files = commitFiles(@files);
	die "nothing to commit\n" if ($toCommit == 0 && (scalar @files) == 0);

	my $nextCommit = getLatestCommit();	
	mkdir ".legit/commits/$nextCommit";
    
    for $file(@files){
		copy($file, ".legit/commits/$nextCommit/") or die "Copy failed: $!";
	} 
	print "Committed as commit $nextCommit\n";
	setLatestCommit($nextCommit + 1);
	shift @ARGV && addtoLog($nextCommit);
}

# This function prints all the commits and their commit messages in order - latest to earliest.
sub gitLog{
	open F, '<', ".legit/log.txt";
	my @lines = <F>;
	printError("your repository does not have any commits yet") if((scalar @lines) == 0);
	print pop @lines while @lines;
}

# This function prints the content of the file from a specified commit or the Index if no commit is specified. 
sub show{
	my($args) = @ARGV;
	my($commit, $file) = split ":", $args;
	if($commit eq ""){
			open F, '<', ".legit/index/$file" or printError("'$file' not found in index");
			print <F>;
			close F;
			exit 0;
	}
	printError("unknown commit '$commit'") if $commit > getLatestCommit() - 1;
	open F, '<', ".legit/commits/$commit/$file" or printError("'$file' not found in commit $commit"); 
	print <F>;
	close F;
}

# This function removes files from either the index or the working directory or both depending on flags provided and status of files.
sub rm{
	printError("your repository does not have any commits yet") if (getLatestCommit() == 0);

	my $force = 0;
	my $cached = 0;

	$force = 1 if ($ARGV[0] eq "--force" && shift @ARGV);
	$cached = 1 if ($ARGV[0] eq "--cached" && shift @ARGV);
	$force = 1 if ($ARGV[0] eq "--force" && shift @ARGV);

	$latestCommit = getLatestCommit() - 1;
	if(!$force){
		foreach my $file (@ARGV){
			printError("'$file' is not in the legit repository") if (!(-e ".legit/index/$file"));
			$valid1 = compare($file,".legit/commits/$latestCommit/$file") == 0 if (-e $file);
			$valid2 = compare(".legit/commits/$latestCommit/$file",".legit/index/$file") == 0;
			$valid3 = compare($file, ".legit/index/$file") == 0;
			printError("'$file' in index is different to both working file and repository") if(!$valid2 && !$valid3);
			printError("'$file' has changes staged in the index") if(!$valid2 && !$cached);
			printError("'$file' in repository is different to working file") if(!$valid1 && !$cached);
		}
	}
	foreach my $file (@ARGV){
		printError("'$file' is not in the legit repository") if (!(-e ".legit/index/$file"));
		unlink $file if (!$cached);
		unlink ".legit/index/$file";
	}
}

# This function prints the status of all files in the repository (working directory + index +  commit). 
sub status{
	my %files = ();
	my $latestCommit = getLatestCommit() - 1;
	printError("your repository does not have any commits yet") if ($latestCommit == -1);
	my @fileNames = ();
	push @fileNames, (glob ".legit/index/*");
	push @fileNames, (glob ".legit/commits/$latestCommit/*");
	push @fileNames, (glob "*");
	foreach my $file(@fileNames){
		next if (-d $file);
		$file =~ s|.legit/index/(.*)|$1|;
		$file =~ s|.legit/commits/$latestCommit/(.*)|$1|;
		$files{$file} = 1;
	}

	foreach $file(sort keys %files){
		print "$file - ";
		$same1 = compare($file,".legit/commits/$latestCommit/$file") == 0 if (-e $file);
		$same2 = compare(".legit/commits/$latestCommit/$file",".legit/index/$file") == 0;
		$same3 = compare($file, ".legit/index/$file") == 0;
		# in Working Directory
		if(-e $file){
			if(!(-e ".legit/commits/$latestCommit/$file")){
				# not in commit and not in index
				if(!(-e ".legit/index/$file")){
					print "untracked\n";
				}
				# not in commit but in index
				else{
					print "added to index\n";	
				}			
			}
			else{
				# in commit but not in index
				if(!(-e ".legit/index/$file")){
					print "untracked\n";
				}
				# in commit and in index
				# same all throught
				elsif($same1 && $same2){
					print "same as repo\n";
				}
				# different all throughout
				elsif (!$same2 && !$same3 && !$same1){
					print "file changed, different changes staged for commit\n";
				}
				# wd == commit != index
				elsif($same1 && !$same2){
					print "file changed, different changes staged for commit\n";
				}
				# wd == index != commit
				elsif($same3 && !$same2){
					print "file changed, changes staged for commit\n";
				}
				# commit == index != wd	
				else{
					print "file changed, changes not staged for commit\n";
				}
			}
		}
		# not in Working Directory
		else{
			if (-e ".legit/commits/$latestCommit/$file"){
				# in commit and in index
				if(-e ".legit/index/$file"){
					print "file deleted\n";
				}
				# in commit but not in index
				else{
					print "deleted\n";
				}
			}
		}
	}
}

# This function creates, deletes or prints names of branches according to the arguments provided.
sub branch{
	my $latestCommit = getLatestCommit() - 1;
	printError("your repository does not have any commits yet") if $latestCommit < 0;
	my $deleteBranch = ($ARGV[0] eq "-d" && shift @ARGV);
	my $branchName = shift @ARGV;
	# delete branch
	if($deleteBranch){
		# error if branch name not provided
		printError("branch name required") if (!$branchName);
		printError("can not delete branch 'master'") if ($branchName eq 'master');
		# branch exists
		if (-e ".legit/branches/$branchName"){
			unlink ".legit/branches/$branchName";
			print "Deleted branch '$branchName'\n";
		}
		# branch does not exist
		else{
			printError("branch '$branchName' does not exist");
		}
	}
	# create branch
	elsif ($branchName){
		# branch already exists
		if (-e ".legit/branches/$branchName"){
			printError("branch '$branchName' already exists");
		}
		# branch does not exist - Create new and make it point to latest commit 
		else{
			open F, '>', ".legit/branches/$branchName";
			print F "$latestCommmit\n";
			close F;
		}	
	}
	# print branch names
	else{
		my @branches = glob ".legit/branches/*";
		foreach my $file (sort @branches){
			$file =~ s|.legit/branches/||;
			print "$file\n";
		}
	}
}

# Helper Functions
sub getLatestCommit{
	open F, '<', ".legit/latestCommit.txt";
	my $latestCommit = 0;
	while (my $line = <F>){
		chomp $line;
		$latestCommit = $line;
	}	
	close F;
	return $latestCommit;
}

sub setLatestCommit{
	my ($latestCommit) = @_;
	open F, '>', ".legit/latestCommit.txt";
	print F "$latestCommit";
	close F;
}

sub addtoLog{
	my($commit) = @_;
	open F, '>>', ".legit/log.txt";
	$commitMssg = $ARGV[0];
	print F "$commit $commitMssg\n";
	close F;
}

sub commitFiles{
	my $latestCommit = getLatestCommit() - 1;
	return @_ if ($latestCommit == -1);
	my(@files) = @_;
	$toCommit = 0;
	for my $file (glob ".legit/commits/$latestCommit/*"){
		my $indexFile = $file;
		$indexFile =~ s|.legit/commits/$latestCommit/(.*)|.legit/index/$1|;
		$toCommit = 1 if(!(-e $indexFile));
	}
	for $file (@files){
		my $diffFile = $file;
		$diffFile =~ s|.legit/index/(.*)|$1|;
		$diffFile = ".legit/commits/$latestCommit/$diffFile";
		if (!(-e $diffFile) || compare($file,$diffFile) != 0 || $toCommit == 1){
			return @files;
		}
	}
	return ();
}

sub printError{
	my ($errorMssg) = @_;
	die "legit.pl: error: $errorMssg\n";
}