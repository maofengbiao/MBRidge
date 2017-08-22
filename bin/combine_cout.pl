#############################################
#Program name:bin/combine_cout
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
my %fhand;
#############################################
my ($in,$out,$cpgpos,$p,$win_max,$Help);
GetOptions
(
	"in=s" => \$in,
	"out=s" => \$out,
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
#&showLog("Start!");
if (defined $out)  { open(STDOUT,  '>', $out)  || die $!; }
##############################################
my @files=(split /\,/,$in);
my $fh;
##############################################
open_files(\@files);
my $sum_num=@files;
my @samps_line;
#chr10   50025   +       CG      CGG     1       0       0
#chr site strand CG context mappability methy unmethy
my $flag=1;
while ($flag==1){
	my ($chr,$site,$str,$cg,$cont,$map,$methy,$unmethy);
	for(my $k=0;$k<$sum_num;$k++){
		my $h=$fhand{$k};
	        my $tmp_line=<$h>;
        	@{$samps_line[$k]}=split(/\s+/,$tmp_line);
	        $flag=0,last if $tmp_line eq "";
		if (@{$samps_line[$k]}!=8){
			$flag=0;
			die "Cout format is wrong, 8 colums are required !!!\n";
			last;
		}
		($chr,$site,$str,$cg,$cont,$map)=@{$samps_line[$k]}[0,1,2,3,4,5];
		$methy+=$samps_line[$k][6];
		$unmethy+=$samps_line[$k][7];
	}
	if ($flag==1){
		print STDOUT "$chr\t$site\t$str\t$cg\t$cont\t$map\t$methy\t$unmethy\n";
	}else{
		last;
	}
}
###read a sample line
                                       
#&showLog("Done!");
sub showLog {
        my ($info) = @_;
        my @times = localtime; # sec, min, hour, day, month, year
	print STDERR sprintf("[%d-%02d-%02d %02d:%02d:%02d] %s
", $times[5] + 1900,$times[4] + 1, $times[3], $times[2], $times[1], $times[0], $info);
}
sub Max{
        my (@aa) = @_;
        if (not @aa) {
                die("Empty array\n");
        }
        my $max=shift @aa;
        foreach  (@aa) {$max=$_ if($_>$max);}
        return $max;
}
sub min {
        my (@aa) = @_;
        if (not @aa) {
                die("Empty array\n");
        }
        my $min=shift @aa;
        foreach  (@aa) {$min=$_ if($_<$min);}
        return $min;
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
sub average{
        my($data) = @_;
        if (not @$data) {
                die("Empty array\n");
        }
        my $total = 0;
        foreach (@$data) {
                $total += $_;
        }
        my $average = $total / @$data;
        return $average;
}
sub stdev{
        my($data) = @_;
        if(@$data == 1){
                return 0;
        }
        my $average = &average($data);
        my $sqtotal = 0;
        foreach(@$data) {
                $sqtotal += ($average-$_) ** 2;
        }
        my $std = ($sqtotal / (@$data-1)) ** 0.5;
        return $std;
}
sub open_files{
        my $files=shift;
        my $num=@$files;
        for(0..$num-1){
                if(@$files[$_]=~/\S+.gz$/){
			open $fhand{$_},"gzip -dc @$files[$_]|" or die $!;
                }else{
			open $fhand{$_},"@$files[$_]" or die "$!";
		}
        }
}
#print STDERR "<--Program	$0	ends --- ".localtime()."\n";
