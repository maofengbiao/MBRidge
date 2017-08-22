#############################################
#Program name:mb-methylback
#Author: Fengbiao Mao
#Email:maofengbiao08@163.com || 524573104@qq.com || maofengbiao@gmail.com
#Tel:18810276383
#version:1.1
#Time:Sat May 18 17:39:17 2013
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
my ($in,$chr,$mb,$dep,$dep,$step,$out,$cpgpos,$p,$win_max,$Help);
GetOptions
(
	"in=s" => \$in,
	"mb=s" => \$mb,
	"st=s" => \$step,
	"dep=s" => \$dep,
	"out=s" => \$out,
	"help" => \$Help,
);
##############################################
my $usage=<<USAGE;
\n Usage : \n perl $0  
	-i <MB-cout>  (chr pos)
	-m <MB-cout>  
	-o <out_file>
	-d <depth> [0]
	-s <step> [201]
	-h <display this help info>\n
USAGE
die $usage if ($Help || ! $in);
#print STDERR "---Program	$0	starts --> ".localtime()."\n";
&showLog("Start!");
##############################################
$step||=201;
$dep||=0;
my $wind=($step-1)/2;
##############################################
if($in=~/\S+.gz$/){
	open IN,"gzip -dc $in |" or die $!;
}else{	
	open IN,"$in" or die $!;
}
if ($mb=~/\S+.gz$/)
{
    open(MBTS, "gzip -dc $mb |") or die $!;
}else
{
    open(MBTS, "<",  $mb) or die $!;
}

#our ($flag,$BSrows)=(0,0);

if (defined $out)  { open(STDOUT,  '>', $out)  || die $!; }
our (%hash_chrlen);
my %hash_cout;
my %hash_group;
my %hash_dep;
while(<MBTS>){
	chomp;		
	my @tmp=split;
	my $methy=0;
	if ($tmp[6]+$tmp[7]>0){
		$methy=$tmp[6]/($tmp[6]+$tmp[7]);
	}
	next if ($tmp[2] eq "-");
	$hash_group{$tmp[0]}{$tmp[1]}=$tmp[6];
	$hash_cout{$tmp[0]}{$tmp[1]}=$methy;
	if ($tmp[6]+$tmp[7]>=$dep){
		$hash_dep{$tmp[0]}{$tmp[1]}=1;
	}else{
		$hash_dep{$tmp[0]}{$tmp[1]}=0;
	}
}
my $methygroup;
while(<IN>){#cout file: chr2    1       +       CG      CGT     0       0       0       1
	chomp;
	my @tmp=split;
	#next if ($tmp[2] eq "-");
	my $row=$tmp[1];
	my ($up,$down)=region($row,$tmp[0]);
	my @methyarray=();
	my $methygroup=0;
	for (my $i=$up;$i<$down;$i++){
		if (exists $hash_cout{$tmp[0]}{$i} &&  $hash_dep{$tmp[0]}{$i}==1){
			push @methyarray,$hash_cout{$tmp[0]}{$i};
			$methygroup+=$hash_group{$tmp[0]}{$i};	
		}
	}
	my $meanmethy=mean(\@methyarray);
	print STDOUT "$_\t$meanmethy\t$methygroup\n";
}
sub region {
	my $row=shift;
	my $chr=shift;
	my $up=$row-$wind;
	my $down=$row+$wind;
	my $check;
	return ($up,$down);
}
&showLog("Done!");
close IN;
sub showLog {
        my ($info) = @_;
        my @times = localtime; # sec, min, hour, day, month, year
	print STDERR sprintf("[%d-%02d-%02d %02d:%02d:%02d] %s\n", $times[5] + 1900,$times[4] + 1, $times[3], $times[2], $times[1], $times[0], $info);
}
sub Max{
        my (@aa) = @_;
        my $max=shift @aa;
        foreach  (@aa) {$max=$_ if($_>$max);}
        return $max;
}
sub mean{        
	my ($data) = shift;       
	my @array=@$data;
	my $average;
	if (@array==0) {            
		#print STDERR "not exitst\n";
		$average=0;
	}else{        
		my $total = 0;        
		foreach (@array) {       
        	$total += $_;    
	    }        
			$average = $total / @array;       
	}	
	return $average;
}
#print STDERR "<--Program	$0	ends --- ".localtime()."\n";
