###################################
#Program name:number
#Author: maofengbiao
#Email:maofengbiao08@163.com|524573104@qq.com
#Tel:15920061519
#version:1.1
#Time:Sun Jul  8 13:08:25 2012
##############################################
#!/usr/bin/perl -w
use strict;
use File::Basename;
#use PerlIO::gzip;
#use Math::CDF qw(:all);
#use Statistics::Basic qw(:all);
#############################################
my ($in,$out,$cpgpos,$p,$win_max)=@ARGV;
my $usage=<<USAGE;
usage : perl $0  <in_file>  <out_file>\n
USAGE
die $usage if @ARGV==0;
#die "usage: perl $0 <in_file>  <out_file>\n" if(@ARGV==0);
#print STDERR "---Program	$0	starts --> ".localtime()."\n";
##############################################




##############################################
if($ARGV[0]=~/\S+.gz/){
	open IN,"gzip -dc $ARGV[0] |" or die $!;
}else{	
	open IN,"$ARGV[0]" or die $!;
}
#open CG,"$ARGV[2]" or die $!;
open OUT,">$ARGV[1]" or die $!;
#open OUT,">:gzip","$out" or die $!;
my $num=0;
while(<IN>){
	chomp;
	next if ($_=~/^#/);
        next if ($_=~/^\s*$/);
	my @tmp=split;
	$num++;
	print OUT "$num\t";
	print OUT join "\t",@tmp,"\n";
}
close IN;
#print STDERR "<--Program	$0	ends --- ".localtime()."\n";
