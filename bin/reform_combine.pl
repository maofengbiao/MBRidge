#############################################
#Program name:combine-model-test
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
my ($in,$out,$trm,$all,$cpgpos,$p,$win_max,$Help);
GetOptions
(
	"in=s" => \$in,
	"out=s" => \$out,
	"t=s" => \$trm,
	"a=s" => \$all,
#	"cpgpos=s" => \$cpgpos,
#	"p=f"=> \$p,
#	"win_max=i"=> \$win_max,
	"help" => \$Help,
);
##############################################
my $usage=<<USAGE;
\n Usage : \n perl $0  
	-i <Test_in_file>
	-t <Train_in_file>  
	-a <ALL_in_file>
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
#my %hashtrm;
##############################################
foreach my $file (@files){
	$fh=open_file($file);
	while(<$fh>){
		chomp;
		my @tmp=split;
		my $id=$tmp[1]."-".$tmp[2];
		my $regress=$tmp[-1];
		$hash{$id}=$regress;
	}
	close $fh;
}
my @files=`ls $trm`;
my $fh;
my %hashtrm;
##############################################
foreach my $file (@files){
        $fh=open_file($file);
        while(<$fh>){
                chomp;
                my @tmp=split;
                my $id=$tmp[0]."-".$tmp[1];
                my $rrbs=$tmp[7];
                $hashtrm{$id}=$rrbs;
        }
        close $fh;
}
##############################################
my @files=`ls $all`;
my $fh;
##############################################
print STDOUT "#chr\tposition\tstrand\tC-pattern\tC-context\tRRBS-methy\tRRBS-depth\tRRBS-rate\tMB-methy\tMB-depth\tMB-rate\tMB_backMethyRate\tMB_backMethyGroup\tCGdensity\tGCcontent\tCGoe\tType\tMBRidge-value\n";
foreach my $file (@files){
        $fh=open_file($file);
        while(<$fh>){
                chomp;
                my @tmp=split;
		my $id=$tmp[0]."-".$tmp[1];
		if($hashtrm{$id}){#RRBS-train
			print STDOUT "$_\tTrain\t$hashtrm{$id}\n";
		}elsif($hash{$id}){#BS-Test
			print STDOUT "$_\tTest\t$hash{$id}\n";
		}else{#MB level=0;
			print STDOUT "$_\tTest(Zero)\t0\n";
		}
		#for output is BS-seq, 4th column
        }
        close $fh;
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
#print STDERR "<--Program	$0	ends --- ".localtime()."\n";
