#!/usr/bin/perl -w
use strict;
use FindBin qw($Bin $Script);
use lib ("$Bin/../lib");
use Parallel::ForkManager;
my $shell=$ARGV[0];
my $wkdir=$ARGV[1];
my $noOfProcesses=$ARGV[2]||1;
my $pm = new Parallel::ForkManager($noOfProcesses);
die "Usage:perl $0 <shell> <dir> <cpu>\n" unless (@ARGV == 3 );
open SH,"$shell"||die"$!";
my $pid;
while(<SH>){
	next if ($_=~/^#/);
	next if ($_=~/^\s*$/);
        my @line=split(/\t/,$_);
$pid = $pm->start and next;
	chdir $wkdir;
	`$_`;
        $pm->finish;
}
$pm->wait_all_children;
exit;

