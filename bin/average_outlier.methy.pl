#############################################
#Program name:average
#Author: Fengbiao Mao
#Email:maofengbiao08@163.com || 524573104@qq.com || maofengbiao@gmail.com
#Tel:18810276383
#version:1.1
#Time:Sat Aug 31 20:54:03 2013
##############################################
#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Long;
use Cwd qw(abs_path);
use Data::Dumper;
#use PerlIO::gzip;
#use Math::CDF qw(:all);
#use Statistics::Basic qw(:all);
#use Math::Trig;
#############################################
my ($in,$out,$cpgpos,$p,$win_max,$Help);
GetOptions
(
	"in=s" => \$in,
	"out=s" => \$out,
#	"cpgpos=s" => \$cpgpos,
#	"p=f"=> \$p,
#	"win_max=i"=> \$win_max,
	"help" => \$Help,
);
##############################################
my $usage=<<USAGE;
\n Usage : \n perl $0  
	-i <in_file>  
	-o <out_file>
	-h <display this help info>\n
USAGE
die $usage if ($Help || ! $in);
#print STDERR "---Program	$0	starts --> ".localtime()."\n";
&showLog("Start!");
if (defined $out)  { open(STDOUT,  '>', $out)  || die $!; }
##############################################
my @files=`ls $in`;
my $fh;
my %hash;
my %hash2;
##############################################
foreach my $file (@files){
	$fh=open_file($file);
	while(<$fh>){
		chomp;
		next if ($.==1);
		my @tmp=split;
		my $id=$tmp[1]."-".$tmp[2];
		push @{$hash{$id}},$_;				
	}
	close $fh;
}
foreach my $k (sort keys %hash){
	my $number=0;
	my $sum=0;
	my $last="";
	foreach my $s (@{$hash{$k}}){
		my @tmp=split /\t/,$s;
		$sum+=$tmp[-1];
		$number++;
		$last=$s;
	}
	my $ave=$sum/$number;
	my $ave=ave_format($ave);
	print STDOUT "$last\t$ave\n"
}
&showLog("Done!");
sub showLog {
        my ($info) = @_;
        my @times = localtime; # sec, min, hour, day, month, year
	print STDERR sprintf("[%d-%02d-%02d %02d:%02d:%02d] %s
", $times[5] + 1900,$times[4] + 1, $times[3], $times[2], $times[1], $times[0], $info);
}
sub Max{
        my (@aa) = @_;
        my $max=shift @aa;
        foreach  (@aa) {$max=$_ if($_>$max);}
        return $max;
}
sub open_file {
        my $file=shift;
	my $fh;
        if($file=~/\S+.gz$/){
                open $fh,"gzip -dc $file |" or die $!;
        }else{
        	open $fh,"$file" or die $!;
        }
        return $fh;
}
sub ave_format {
	my $ave=shift;
	if ($ave>1){
		$ave=1;
	}elsif($ave<0){
		$ave=0;
	}
	return $ave;
}
#print STDERR "<--Program	$0	ends --- ".localtime()."\n";
