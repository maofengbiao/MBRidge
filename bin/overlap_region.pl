#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
my $usage =<<"USAGE";
Command: perl $0 <sorted pos file> <gene region file> <outdir>
USAGE

my ($pos_file, $region_file,$outdir) = @ARGV;

die $usage unless $pos_file && $region_file && $outdir;

my %region;
my %index;
my @files=`ls $region_file`;
my $outfh;
my $fh;
foreach my $file (@files){
        my $name=basename($file);#3-UTR.sorted.bed 
	my @tmp=split (/\./,$name);
	my $ele=$tmp[0];
	my $outfile=$outdir."/ele.".$ele.".input";
	open $outfh,">$outfile" or die $!;	
	read_region($file, \%region, \%index);
	parse_file($pos_file, \%region, \%index,$outfh);
}
sub read_region{
	my ($file, $ref, $index_ref) = @_;
	if ($file=~/\S+\.gz$/){
		open $fh, "gzip -dc $file|" or die $!;
	}else{
		open $fh, $file or die $!;
	}
	while (<$fh>){
		chomp;
		my @tmp = split;
		#push @{$ref->{$tmp[0]}}, [$tmp[1], $tmp[2],$tmp[3],$tmp[4],$tmp[5]];
		push @{$ref->{$tmp[0]}}, [$tmp[1], $tmp[2]];
	}
	close $fh;
	
	for my $chr (keys %$ref){
		@{$ref->{$chr}} = sort {$a->[0] <=> $b->[0]} @{$ref->{$chr}};
		$index_ref->{$chr} = 0;
	}
}

sub parse_file{
	my ($file, $ref, $index_ref,$outfh) = @_;
	if ($file=~/\S+\.gz$/){
                open $fh, "gzip -dc $file|" or die $!;
        }else{
		open $fh, $file or die $!;
	}
	while (<$fh>){ #chr10   50006   +       CHH     CCT     0       0       0       1
		chomp;
		my @tmp = split;
		next unless defined $index_ref->{$tmp[0]} ;	 ## out of chr
			
		my $flag = 1;
		my $isOverlap = 0;
		for(my $i = $index_ref->{$tmp[0]}; $i < @{$ref->{$tmp[0]}}; $i++){#each chr, each site.
			if ($tmp[1] < $ref->{$tmp[0]}[$i][0]){$index_ref->{$tmp[0]} = $i;last;}
			next if $tmp[1] > $ref->{$tmp[0]}[$i][1];
			
			if ($flag){
				$index_ref->{$tmp[0]} = $i;
				$flag = 0;
			}
			$isOverlap = 1;
			last;
		}

		if ($isOverlap){
			print $outfh "$_\n";
		}
	}
}


