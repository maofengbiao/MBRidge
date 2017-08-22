#############################################
#Program name:CG
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
my ($in,$out,$cpgpos,$pat,$win_max,$Help);
GetOptions
(
	"in=s" => \$in,
	"out=s" => \$out,
#	"cpgpos=s" => \$cpgpos,
	"pat=s"=> \$pat,
#	"win_max=i"=> \$win_max,
	"help" => \$Help,
);
##############################################
my $usage=<<USAGE;
\n Usage : \n perl $0  
	-i <in_file>  
	-o <out_file>
	-p <pattern,CG/CHG/CHH> [CG]
	-h <display this help info>\n
USAGE
die $usage if ($Help || ! $in);
#print STDERR "---Program	$0	starts --> ".localtime()."\n";
&showLog("Start!");
if (defined $out)  { open(STDOUT,  '>', $out)  || die $!; }
##############################################
my @files=`ls $in`;
my $fh;
$pat||="CG";
##############################################
foreach my $file (@files){
	$fh=open_file($file);
	while(<$fh>){
		chomp;
		my @tmp=split /\t/,$_;
		if($.==1){
		#	print STDOUT "$_\tPattern\n";
			next;
		}
		next if ($tmp[3] eq "");
		#next if ($tmp[4]=~/NA/i);
		my $seq=$tmp[3];
		$seq=uc($seq);
		if($tmp[2] eq "-"){
			$seq=reverse($seq);
			$seq=~tr/ATCGN/TAGCN/;
		}
		my @t=split //,$seq;
		next if ($t[2] ne "C");
		my $unmethy=0;
		if ($t[3]=~/G/i){
			if ($pat=~/CG/i){
				if ($tmp[5]>=$tmp[6]){
					$unmethy=$tmp[5]-$tmp[6];
				}else{
					$tmp[5]=$tmp[6];
				}
				print STDOUT "$tmp[0]\t$tmp[1]\t$tmp[2]\tCG\t$tmp[3]\t1\t$tmp[6]\t$unmethy\n";
			}
		}else{
			if ($t[4]=~/G/i){
				if ($pat=~/CHG/i){
                                	if ($tmp[5]>=$tmp[6]){
                        	                $unmethy=$tmp[5]-$tmp[6];
                	                }else{
        	                                $tmp[5]=$tmp[6];
	                                }
					print STDOUT "$tmp[0]\t$tmp[1]\t$tmp[2]\tCHG\t$tmp[3]\t1\t$tmp[6]\t$unmethy\n";
				}
			}else{
				if ($pat=~/CHH/i){
                                        if ($tmp[5]>=$tmp[6]){
                                                $unmethy=$tmp[5]-$tmp[6];
                                        }else{
                                                $tmp[5]=$tmp[6];
                                        }
					print STDOUT "$tmp[0]\t$tmp[1]\t$tmp[2]\tCHH\t$tmp[3]\t1\t$tmp[6]\t$unmethy\n";
				}
			}
		}
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
