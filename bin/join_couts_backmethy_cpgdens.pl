#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: distribution.pl
#
#        USAGE: ./distribution.pl  
#
#  DESCRIPTION: C methylation level distribution for elements between two samples
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Mao  FengBiao (MFB), maofengbiao@gmail.com
# ORGANIZATION: BIOLS,CAS
#      VERSION: 1.0
#      CREATED: 11/29/2012 09:52:14 AM
#     REVISION: ---
#===============================================================================
#!/usr/bin/perl 
#==============================================================================#
#-------------------------------help-info-start--------------------------------#
=head1 Name
    
    distribution.pl --> <CURSOR>


=head1 Usage


    perl  distribution.pl  [options] <outfile>
-help    ( tag)    print this help to screen
-log     ( str)    write log to a file
-d0      ( str)    MB.couts
-d1      ( str)    RRBS.couts
-d2      ( str)    read cpg density
-d3      ( str)    read cout files of backmethy from a directory 
-o       ( str)    outfile

 
=head1 Example


    perl  distribution.pl [options] <outfile>
    perl  distribution.pl  ---


=head1 Version


    Verion : 1.0
    Created : 11/29/2012 09:52:14 AM 
    Updated : ---
    LastMod : ---




=head1 Contact


    Author : MaoFengBiao (MFB)
    E-mail : maofengbiao@gmail.com
    Institute: BIOLS,CAS,CHINA


=cut
#-------------------------------help-info-end--------------------------------#
#============================================================================#
use warnings;
use strict;
use Getopt::Long;
use File::Basename;
use Cwd qw(abs_path);
use FindBin qw($Bin $Script);
#use lib("/public/home/maofb/my_perl/perl_packages/lib/perl5/site_perl/5.8.8");
#use lib ("/public/home/maofb/my_perl/perl_packages/PerlIO-gzip-0.18/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi");
#use PerlIO::gzip;
#use lib ("/public/software/perl-5.12.2/lib/perl5/site_perl/5.8.8");
#use lib ("/public/software/perl-5.12.2/lib64/perl5/site_perl/5.8.8");
#use Math::Combinatorics;
#  combine [mplements nCk (n choose k), or n!/(k!*(n-k!)). returns all unique unorderd combinations of k items from set n.items in n are assumed to be character data, and are copied into the return data structure]ents nCk (n choose k), or n!/(k!*(n-k!)). returns all unique unorderd combination
#  derange [implements !n, a derangement of n items in which none of the items appear in their originally ordered place.]
#  permute [implements nPk (n permute k) (where k == n), or n!/(n-k)! returns all unique permutations of k items from set n (where n == k, see "Note" below).  items in n are assumed to be character data, and are copied into the return data structure.], or n!/(n-k)! returns all unique permutati#  factorial [calculates n! (n factorial)]
#use List::Util qw(first max maxstr min minstr reduce shuffle sum);
#use List::MoreUtils qw(:all);
#use List::MoreUtils qw(any all none notall true false firstidx first_index lastidx last_index insert_after insert_after_string apply after after_incl before before_incl indexes firstval first_value lastval last_value each_array each_arrayref pairwise natatime mesh zip uniq minmax);
#use Statistics::Basic qw(:all);
#vector():mean() average() avg():median():mode():variance() var()
#use  Math::CDF qw(:all);
#    pbeta(), qbeta()          [Beta Distribution]
#    pchisq(), qchisq()        [Chi-square Distribution]
#    pf(), qf()                [F Distribution]
#    pgamma(), qgamma()        [Gamma Distribution]
#    pnorm(), qnorm()          [Standard Normal Dist]
#    ppois(), qpois()          [Poisson Distribution]
#    pt(), qt()                [T-distribution]
#    pbinom()                  [Binomial Distribution]
#    pnbinom()                 [Negative Binomial Distribution]
my ($Need_help, $dir0,$cn, $sample,$filter,$dir1,$dir2,$ele,$pat,$Log_file, $Out_file ,$ne,$l1,$l2,$dir3);
GetOptions(
 "help"  => \$Need_help,
 "log=s"  => \$Log_file,
 "pat=s" => \$pat,
 "cn=f" => \$cn,
 "d0=s"  => \$dir0,
 "d1=s"  => \$dir1,
 "d2=s"  => \$dir2,
 "d3=s"  => \$dir3,
# "s=s"  => \$sample,
 "out=s" => \$Out_file,
);


die `pod2text $0` if ($Need_help || (! $dir1) || (! $Out_file));

$cn ||=1.5;
$pat ||="CG";
$filter ||=10;
$pat=uc($pat);
$ne ||="ele";
#$sample||="SP";
$l1 ||="sp1";
$l2 ||="sp2";
#============================================================================#
#                              Global Variable                               #
#============================================================================#
#my $Input_file  = $ARGV[0]  if (exists $ARGV[0]); 


#============================================================================#
#                               Main process                                 #
#============================================================================#
print STDERR '---Program starts --> '.localtime()."\n";

my $outdir;

if(defined $Log_file)
{ open(STDERR, '>', $Log_file) or die $!; }
if(defined $Out_file){
    $outdir=abs_path($Out_file);
    $outdir=dirname ($outdir);
    open(STDOUT, '>', $Out_file) or die $!; 
}else
{
    $outdir=$Bin;
}
my @files0=`ls $dir0`;
my @files1=`ls $dir1`;
my @files2=`ls $dir2`;
my @files3=`ls $dir3`;
chomp @files0;
chomp @files1;
chomp @files2;
chomp @files3;
my $f0=@files0;
my $f1=@files1;
my $f2=@files2;
my $f3=@files3;
@files0=sort(@files0);
@files1=sort(@files1);
@files2=sort(@files2);
@files3=sort(@files3);
my %hashfile;

#die "dir1 does not match dir2 ($f1 ne $f2) \n" if ($f1 ne $f2);

#for (0..($f1-1)){
#	$hashfile{$files1[$_]}=$files2[$_];
#}
my %hashrrbs;
my %hash_backmethy;
showLog("Begin : Reading RRBS couts ...");
foreach my $file (@files1){
	if ($file=~/\S+\.gz$/){
		open IN, "gzip -dc $file|" or die $!;
	}else{
		open IN, "$file" or die $!;	
	}
	while(<IN>){
		chomp;
		my $line=$_;
		my @tmp=split;
#		next if ($tmp[3] ne "CG");
		my $id=$tmp[0]."_".$tmp[1];
		my $rate=0;
		if ($tmp[6]+$tmp[7]>0){
			$rate=$tmp[6]/($tmp[6]+$tmp[7]);
		}
		$hashrrbs{$id}=$line."\t".$rate;
	}
	close IN;
}
my %hashmb;
showLog("Begin : Reading MB-seq couts ...");
foreach my $file (@files0){
        if ($file=~/\S+\.gz$/){
                open IN, "gzip -dc $file|" or die $!;
        }else{
                open IN, "$file" or die $!;
        }
        while(<IN>){
                chomp;
                my $line=$_;
                my @tmp=split;
#                next if ($tmp[3] ne "CG");
                my $id=$tmp[0]."_".$tmp[1];
		my $rate=0;
                if ($tmp[6]+$tmp[7]>0){
                        $rate=$tmp[6]/($tmp[6]+$tmp[7]);
                }
                $hashmb{$id}=$line."\t".$rate;
		if (! exists $hashrrbs{$id}){
			my $rrbsline=join "\t",($tmp[0],$tmp[1],$tmp[2],$tmp[3],$tmp[4],$tmp[5],"NA","NA","NA");
			$hashrrbs{$id}=$rrbsline;
		}
        }
        close IN;
}
showLog("Begin : Reading file backmethy...");
foreach my $file (@files3){
    if ($file=~/\S+\.gz$/){
    	open IN, "gzip -dc $file|" or die $!;
    }else{
    	open IN, "$file" or die $!;
    }
    while(<IN>){
        chomp;
        my $line=$_;
        my @tmp=split;
#	next if ($tmp[3] ne "CG");
        my $id=$tmp[0]."_".$tmp[1];
        $hash_backmethy{$id}=$tmp[-2]."\t".$tmp[-1];
    }
    close IN;
}
showLog("Begin : Reading file CGdensity...");
foreach my $file (@files2){
    if ($file=~/\S+\.gz$/){
        open IN, "gzip -dc $file|" or die $!;
    }else{
        open IN, "$file" or die $!;
    }
    while(<IN>){##chr    pos     CGnum   window  CGdensity       chrlength       strand  GCcontent       CGoe
        chomp;
        my $line=$_;
        my @tmp=split;
        my $id=$tmp[0]."_".$tmp[1];
        if (exists $hashmb{$id} && exists $hash_backmethy{$id}){
			print STDOUT "$hashmb{$id}\t$hashrrbs{$id}\t$hash_backmethy{$id}\t$tmp[4]\t$tmp[7]\t$tmp[8]\n";
		}
    }
	close IN;
}
sub showLog {
        my ($info) = @_;
        my @times = localtime; # sec, min, hour, day, month, year
        print STDERR sprintf("[%d-%02d-%02d %02d:%02d:%02d] %s\n", $times[5] + 1900,$times[4] + 1, $times[3], $times[2], $times[1], $times[0], $info);
}
print STDERR '---Program  ends  --> '.localtime()."\n";


#============================================================================#
#                               Subroutines                                  #
#============================================================================#

