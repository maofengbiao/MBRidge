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
-d1      ( str)    read cout files of MB2 from a directory 
-d2      ( str)    read cout files of RRBS from a directory 
-p       ( str)    C patterns (C/CG/CHH/CHG) [CG]
-f1      ( int)    filtered depth [0]
-f2      ( int)    filtered depth [10]
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
my ($Need_help, $cn, $sample,$filterA,$filterB,$dir1,$dir2,$ele,$pat,$Log_file, $Out_file ,$ne,$l1,$l2);
GetOptions(
 "help"  => \$Need_help,
 "log=s"  => \$Log_file,
 "pat=s" => \$pat,
 "f1=i" => \$filterA,
 "f2=i" => \$filterB,
 "cn=f" => \$cn,
 "d1=s"  => \$dir1,
 "d2=s"  => \$dir2,
# "s=s"  => \$sample,
 "out=s" => \$Out_file,
);


die `pod2text $0` if ($Need_help || (! $dir1) || (! $Out_file));

$cn||=1.5;
$pat||="CG";
$pat=uc($pat);
$ne||="ele";
#$sample||="SP";
$l1||="sp1";
$l2||="sp2";
$filterA||=0;
$filterB||=10;
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
    if($Out_file=~/\S+.gz$/){
        open(STDOUT, ">:gzip", $Out_file) or die $!;    
    }else{ 
        open(STDOUT, '>', $Out_file) or die $!; 
    }
}else
{
    $outdir=$Bin;
}

my @files1=`ls $dir1`;
my @files2=`ls $dir2`;

chomp @files1;
chomp @files2;
my $f1=@files1;
my $f2=@files2;
@files1=sort(@files1);
@files2=sort(@files2);
my %hashfile;

die "dir1 does not match dir2 ($f1 ne $f2) \n" if ($f1 ne $f2);

for (0..($f1-1)){
	$hashfile{$files1[$_]}=$files2[$_];
}

showLog("Begin : Reading couts file and calculating methylation distribution in regions of element...");

foreach my $file (keys %hashfile){
		my $file1=$file;
		chomp $file1;
		my $file2=$hashfile{$file};
		chomp $file2;
		print STDERR "file1-->$file1\tfile2-->$file2\n";
		if ($file1=~/\S+.gz$/){
			open(IN1, "<:gzip", $file1) or die $!;
		}else{
			open(IN1, "<", $file1) or die $!;
		}
		if ($file2=~/\S+.gz$/){
            open(IN2, "<:gzip", $file2) or die $!;
        }else{
            open(IN2, "<", $file2) or die $!;
        }
		my $vale1=1;
		my $vale2=1;
    	my ($lineA,$lineB);
		while(1){#chrM    3347    +       CHH     CCT     1       45      9842    0
			if($vale1==1){
		    	$lineA=<IN1>;#MB2
			}
			if($vale2==1){
	        	$lineB=<IN2>;#RRBS
			}
        	last unless $lineB;
			last unless $lineA;
			($vale1,$vale2)=(0,0);

			chomp $lineA;
	    	chomp $lineB;
	        my @lineA_tmp=split(/\t/,$lineA);
    	    my @lineB_tmp=split(/\t/,$lineB);
			#next if ($lineA_tmp[2] ne "+");
			if ($lineA_tmp[1] < $lineB_tmp[1]){
				($vale1,$vale2)=(1,0);
				next;
			}elsif($lineA_tmp[1] > $lineB_tmp[1]){
				($vale1,$vale2)=(0,1);
				next;
			}else{
				($vale1,$vale2)=(1,1);
			}
			my $type=$lineA_tmp[3];
			if ($pat ne  "C"){
				next if ($type ne $pat);
			}
			my $point_fold_A=$lineA_tmp[6]+$lineA_tmp[7];
    	    my $point_fold_B=$lineB_tmp[6]+$lineB_tmp[7];
        	next if $point_fold_A<$filterA;
	        next if $point_fold_B<$filterB;
			my $cnA=$lineA_tmp[5];
			my $cnB=$lineB_tmp[5];
#			next if ($cnA > $cn);
#			next if ($cnB > $cn);
			my $chr=$lineA_tmp[0];
			my $site=$lineA_tmp[1];
			my $strand=$lineA_tmp[2];

			my $rateA=0;
			if ($point_fold_A >0) {
				$rateA=$lineA_tmp[6]/$point_fold_A;
			}
			my $rateB=0;
    	    if ($point_fold_B >0) {
        	    $rateB=$lineB_tmp[6]/$point_fold_B;
        	}
			print STDOUT join "\t",@lineA_tmp,@lineB_tmp,$rateA,$rateB;
			print STDOUT "\n";
		}
		close IN1;
		close IN2;
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

