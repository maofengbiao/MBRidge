#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: cpgdensity.pl
#
#        USAGE: ./cpgdensity.pl  
#
#  DESCRIPTION: get the cpg density from fasta under setting window !
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Mao  FengBiao (MFB), maofengbiao@gmail.com
# ORGANIZATION: BIOLS,CAS
#      VERSION: 1.0
#      CREATED: 11/24/2012 04:01:50 PM
#     REVISION: ---
#===============================================================================
#!/usr/bin/perl 
#==============================================================================#
#-------------------------------help-info-start--------------------------------#
=head1 Name
    
    cpgdensity.pl --> <CURSOR>


=head1 Usage


    perl  cpgdensity.pl  [options] <input file: reference(fasta format)>

	-help	( tag)	print this help to screen
    	-log	( str)	write log to a file
	-d	( str)	write result to a directory [./]
	-p      ( str)  patterns of context [CG]
	-r	( int)	radius for the density [100]
 
=head1 Example


    perl  cpgdensity.pl  input_file
    perl  cpgdensity.pl  ---


=head1 Version


    Verion : 1.0
    Created : 11/24/2012 04:01:50 PM 
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
use Getopt::Long;
use File::Basename;
use Cwd qw(abs_path);
use FindBin qw($Bin $Script);
GetOptions(
 "help"  => \$Need_help,
 "log=s"  => \$Log_file,
 "directory=s"  => \$dir,
 "pat=s"  => \$pat,
 "radius=i"  => \$rad,
);


die `pod2text $0` if ($Need_help || @ARGV==0);


#============================================================================#
#                              Global Variable                               #
#============================================================================#
my $Input_file  = $ARGV[0]  if (exists $ARGV[0]); 


#============================================================================#
#                               Main process                                 #
#============================================================================#


if(defined $Input_file){
	if ($Input_file=~/\S+.gz$/){
		open(STDIN, "gzip -dc $Input_file |") or die $!;
	}else{
		open(STDIN, "<", $Input_file) or die $!;
	}
}	
if(defined $Log_file)
{ open(STDERR, '>', $Log_file) or die $!; }
if(defined $Out_file){
	open(STDOUT, '>', $Out_file) or die $!; 
}

print STDERR '---Program starts --> '.localtime()."\n";

my $seq="";
my @l2a;
my $chr;
my $oldchr;
my $len=0;
$rad ||=100;
$pat ||="CG";
$dir ||="$Bin";
my %hash;

while(<STDIN>){
	chomp;
	next if(m/^$/);
	@l2a = split /\s+/;
	if ($l2a[0]=~/^>(\S+)/)
	{
		$chr=$1;
		if ($seq ne "")
	    	{
			deal ($oldchr,\$seq);
    		}
		$seq="";
		$len=0;
		close CHR;
	}else{
		$oldchr=$chr;
		$seq.=uc($l2a[0]);
		$len+=length($l2a[0]);
	}
}
if ($seq ne "")
{
#	open CHR,">$dir/$oldchr.cg.density" or die $!;
        deal ($oldchr,\$seq);
        $seq="";
        $len=0;
        close CHR;
}
print STDERR '---Program  ends  --> '.localtime()."\n";
#============================================================================#
#                               Subroutines                                  #
#============================================================================#
sub deal
{
	my ($oldchr,$seq) = @_;
	open STDOUT,">$dir/$oldchr.CG.density" or die $!;
	print STDOUT "#CG_chr\tCG_locus\tCG_number\twindow_size\tCG_density\tchr_length\tstrand\tGC_content\tCpGoe\n";
        my $start1 = index ($$seq,"CG");
	my @pos=();
	my @postmp=();
	my @cptmp=();
        while ($start1 != -1)
	{
		my $t=$start1+1;#local position
		my $str=$t-$rad;
	        my $end=$t+$rad;
		if ($str<1)
        	{
            		$str=1;
	        	$end=2*$rad+1;
    	    	}
        	elsif($end > $len)
	        {
    	        	$str=$len-2*$rad;
        		$end=$len;
	        }
		#Begin
			push @pos,[$str,$end,$t];
			@postmp=@pos;#copy
			foreach my $it (@pos){#local one for others(including local)
				my @a=@{$it};
				if($t<=$a[1] && $t>=$a[0])
				{
					$hash{$a[2]}++;#each CG pos ++; $t is within.
				}elsif($t<$a[0])#Error situation!
				{
					last;
				}else#outer & print!
				{
#					my $reg=(2*$rad+1);
					my $reg=$a[1]-$a[0]+1;
					my $seqs=substr($$seq,$a[0]-1,$reg);
					my $c=($seqs=~s/C/C/g);
					my $g=($seqs=~s/G/G/g);
					my $gc=($c+$g)/$reg;
					my $oe=$hash{$a[2]}*$reg/($c*$g);
					my $rate=$hash{$a[2]}/$reg;
					print STDOUT "$oldchr\t$a[2]\t$hash{$a[2]}\t$reg\t$rate\t$len\t+\t$gc\t$oe\n";
					shift @postmp;# shift the local/first CG of postmp.
				}
			}
			foreach my $k (@postmp)#others(including local) for local one
			{
				my @a=@{$k};
				if( $a[2]>= $str && $a[2]<= $end)
				{
					$hash{$t}++;
				}	
			}	
			$hash{$t}-=1;#twice counts
			@pos=@postmp;
			#new turn!
			$offset = $start1 + 1;
            		$start1 = index($$seq, "CG", $offset);
     	}
	foreach my $item (@pos)#for the terminus
	{
		my @a=@{$item};
		my $reg=$a[1]-$a[0]+1;
		my $seqs=substr($$seq,$a[0]-1,$reg);
                my $c=($seqs=~s/C/C/g);
                my $g=($seqs=~s/G/G/g);
                my $gc=($c+$g)/$reg;
                my $oe=$hash{$a[2]}*$reg/($c*$g);
		my $rate=$hash{$a[2]}/$reg;
		print STDOUT "$oldchr\t$a[2]\t$hash{$a[2]}\t$reg\t$rate\t$len\t+\t$gc\t$oe\n";
	}
}
