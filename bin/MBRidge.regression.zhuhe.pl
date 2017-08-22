#############################################
#Program name:MBRidge.regression
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
my ($test,$out,$s,$model,$name,$alpha,$p,$handle,$win_max,$outdir,$Help,$zhuhe);
GetOptions
(
	"t=s" => \$test,
	"out=s" => \$outdir,
	"s=f" => \$s,
	"zhuhe=s" => \$zhuhe,
	"model=s" => \$model,
	"name=s" => \$name,
	"a=f" => \$alpha,
	"k=s" => \$handle,
	"help" => \$Help,
);
##############################################
my $usage=<<USAGE;
\n Usage : \n perl $0  
	-t <test_in_file>  
	-k <handle>
	-n <name>
	-m <model_file>
	-o <out_dir>
	-s <s> [0.06]
	-a <a> [0]
	-z <zhuhe>
	-h <display this help info>\n
USAGE
die $usage if ($Help || ! $test);
#print STDERR "---Program	$0	starts --> ".localtime()."\n";
&showLog("Start!");
if (defined $out)  { open(STDOUT,  '>', $out)  || die $!; }
##############################################
my @files=`ls $model`;
my $fh;
my %fhand;
=cut
$s||=0.06;
$alpha||=0;
$handle||="half";
=cut
##############################################
foreach my $file (@files){
		chomp $file;
		my @tmp=split;
		my $name=basename($file);#ele.3-UTR.input 
	        my @tmp=split (/\./,$name);
        	my $ele=$tmp[1];
	        my $outR=$outdir."/Ridge.".$ele.".R";
		open OUT ,">$outR" or die $!;
		if ($handle=~/rand/){
			print OUT "setwd(\"$outdir\")
library(MASS)
library(glmnet)
data<-read.table(\"$file\")
names(data)<-c(\"chr\",\"pos\",\"strand\",\"C-pattern\",\"C-context\",\"RRBSmethy\",\"RRBSdepth\",\"RRBSrate\",\"MBmethy\",\"MBdepth\",\"MBrate\",\"backmethyRate\",\"backmethygroup\",\"CGdensity\",\"GCcoutent\",\"CGoe\")
data1=data[data[,11]>0,]
data2=data[data[,11]==0,]
n<-nrow(data1)
index<-as.integer(runif(n/2,1,n))
dataTrain<-data1[index,]
dataTest<-data1[-index,]
toff <- dataTrain\$RRBSrate
toff2 <- data2\$RRBSrate
dataXTrain<-dataTrain[,c($zhuhe)]#c(9,10,11,12,13,14,15,16)
dataXTest<-dataTest[,c($zhuhe)]#c(9,10,11,12,13,14,15,16)
regressionModel<-glmnet(as.matrix(dataXTrain),toff,alpha=$alpha)
result<-predict(regressionModel,as.matrix(dataXTest),s=$s)
origin<-c(dataTest\$RRBSrate,toff2)
output<-c(result,toff2);
output[output>1]=1
output[output<0]=0
pearsoncor<-cor(cbind(origin,output))[1,2]
print(paste(\"Pearson correlation is\",pearsoncor,sep=\" \"))
##test...
datatest<-read.table(\"$test\")
data=data[data[,11]>0,]
datatest=datatest[datatest[,11]>0,]
names(datatest)<-c(\"chr\",\"pos\",\"strand\",\"C-pattern\",\"C-context\",\"RRBSmethy\",\"RRBSdepth\",\"RRBSrate\",\"MBmethy\",\"MBdepth\",\"MBrate\",\"backmethyRate\",\"backmethygroup\",\"CGdensity\",\"GCcoutent\",\"CGoe\")
dataTrain<-data
dataTest<-datatest
toff<-dataTrain\$RRBSrate
dataXTrain<-dataTrain[,c($zhuhe)]
dataXTest<-dataTest[,c($zhuhe)]
regressionModel<-glmnet(as.matrix(dataXTrain),toff,alpha=$alpha)
result<-predict(regressionModel,as.matrix(dataXTest),s=$s)
write.table(cbind(datatest,result),\"$name.regression.result.xls\",sep=\"\\t\",quote=F)
"
		}else{
			print OUT "setwd(\"$outdir\")
library(MASS)
library(glmnet)
data<-read.table(\"$file\")
names(data)<-c(\"chr\",\"pos\",\"strand\",\"C-pattern\",\"C-context\",\"RRBSmethy\",\"RRBSdepth\",\"RRBSrate\",\"MBmethy\",\"MBdepth\",\"MBrate\",\"backmethyRate\",\"backmethygroup\",\"CGdensity\",\"GCcoutent\",\"CGoe\")
data1=data[data[,11]>0,]
data2=data[data[,11]==0,]
n<-nrow(data1)
index<-1:(ceiling(n/2))
dataTrain<-data1[index,]
dataTest<-data1[-index,]
toff<-dataTrain\$RRBSrate
toff2 <- data2\$RRBSrate
dataXTrain<-dataTrain[,c($zhuhe)]
dataXTest<-dataTest[,c($zhuhe)]
regressionModel<-glmnet(as.matrix(dataXTrain),toff,alpha=$alpha)
result<-predict(regressionModel,as.matrix(dataXTest),s=$s)
origin<-c(dataTest\$RRBSrate,toff2)
output<-c(result,toff2);
output[output>1]=1
output[output<0]=0
pearsoncor<-cor(cbind(origin,output))[1,2]
print(paste(\"Pearson correlation is\",pearsoncor,sep=\" \"))
##Test...
datatest<-read.table(\"$test\")
data=data[data[,11]>0,]
datatest=datatest[datatest[,11]>0,]
names(datatest)<-c(\"chr\",\"pos\",\"strand\",\"C-pattern\",\"C-context\",\"RRBSmethy\",\"RRBSdepth\",\"RRBSrate\",\"MBmethy\",\"MBdepth\",\"MBrate\",\"backmethyRate\",\"backmethygroup\",\"CGdensity\",\"GCcoutent\",\"CGoe\")
dataTrain<-data
dataTest<-datatest
toff<-dataTrain\$RRBSrate
dataXTrain<-dataTrain[,c($zhuhe)]
dataXTest<-dataTest[,c($zhuhe)]
regressionModel<-glmnet(as.matrix(dataXTrain),toff,alpha=$alpha)
result<-predict(regressionModel,as.matrix(dataXTest),s=$s)
write.table(cbind(datatest,result),\"$name.regression.result.xls\",sep=\"\\t\",quote=F)
";			
	}
	#close $fh;
	`R CMD BATCH  $outR`;
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
                if(@$files[$_]=~/\S+.gz$/){open $fhand{$_},"gzip -dc @$files[$_]|" or die $!;
                }else{open $fhand{$_},"@$files[$_]" or die "$!";}
        }
}
#print STDERR "<--Program	$0	ends --- ".localtime()."\n";
