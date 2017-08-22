
MBRidge 1.1.9

1. Introduction
   To overcome the limitations of existing methods in detecting DNA
methylation, we modified the MeDIP-seq protocol to encompass
bisulfite-treatment, which we call MeDIP-bisulfite sequencing (MB-seq). We
innovatively introduced the hydroxyl-methylated Illumina adapters (all the
cytosines in the adapters were hydroxyl-methylated) in MB-seq, brought an
easier protocol compared with MeDIP-Bseq. Moreover, a clear superiority of
MB-seq is that it can be used to quantify methylation levels at single-base
resolution, which was not mentioned by MeDIP-Bseq. MB-seq presented relative
methylation levels which are somewhat linearly inflated compared with actual
methylation levels. Therefore, we developed MBRidge, a novel ridge regression
model-based algorithm that integrates MB-seq and RRBS data to predict DNA
methylation levels at single CpG resolution. In order to evaluate the MBRidge,
we took out MBRidge and MethylC-seq of the same batch of DNA from a human
ovarian epithelial cell lines which was immortalized with SV40 T/t antigens
and the human catalytic subunit of telomerase (T29). Our study demonstrated
that MBRidge could detect the genome-wide methyaltion level of individual
5mCpG sites precisely, and reduce the cost dramatically compared with MethylC-seq.
   MBRidge is implemented in the Perl && Python language and run in an operating 
64-bit system-independent manner. It can allow users to do estimate genome-wide 
single-base methylation level from MB-seq data combined with RRBS data. For the 
input data, MBRidge supports FASTQ or gzipped FASTQ format of unmapped reads, and 
also accept the SAM/BAM format of mapped reads,and Cout format of methylation 
calling. If FASTQ format, both various read length and single-end/paired-end reads 
are accepted.

   MBRidge is under the GNU General Public License v3.0 (GPLv3).

2. Installation

   MBRidge is designed for linux64 platform. MBRidge allows trading off between 
speed/memory usage/calling sensitivity. For human genome, the typical memory 
usage is 9GB. 

Platform and environment
    
 System: Linux or UNIX
 Software: perl>=5.8.8; R>=2.15; python>=2.7.

First unpackage the source code:
    $ tar zxvf MBRidge-1.1.9.tgz
Then enter the directory:
    $ cd MBRidge-1.1.9
Finally, Make executable binary:
    $ sh install.sh

For test:
   When input format of MB-seq and RRBS both is cout.
    $ cd MBRidge-1.1.9/test/
    $ sh MBcout_RRBScout_test.sh 
   When input format of MB-seq is cout and RRBS both is fq.
    $ cd MBRidge-1.1.9/test/
    $ sh MBcout_fq_test.sh
   When input format of MB-seq is fq and RRBS both is cout.
    $ cd MBRidge-1.1.9/test/
    $ sh MBfq_RRBScout_test.sh
   When input format of MB-seq and RRBS both is fq.
    $ cd MBRidge-1.1.9/test/
    $ sh MBfq_RRBSfq_test.sh

3. Usage

============================================================================
============================================================================
./MBRidge
---------
____        ____   _ ______    _________             _
M _ \      / _ M  B B_____ \  R R_____ R\    o      d |
| |\ \    / /| |  | |_____| | | |_____| |   i i  /--| |  -----     e-----e
| | \ \  / / | |  | |_____| | | |_  __|_|   | | / / | | g g--\ \  / /____\\
| |  \ \/ /  | |  | |_____| | | | \ \____   | | | | | | | |  | |  | |___| |
M_M   \__/   M_M  B_B______/  R_R  \_____R  |_| \_\_|_| \ \__| |  \ \_____
                                                             | |   \_____/
                                                         ____/ /
                                                         \____/   
============================================================================
============================================================================
Welcome to MBRidge


Description:

	Estimating genome-wide single-base methylation level from MB-seq data
combined with RRBS data. We apply algorithm of Ridge regression to calibrate
MB-seq data into absolute methylation levels at single-CpG resolution.


Version:1.1.9

Usage:

        ./MBRidge  -f1 <format of MB-seq> -i1 <input.list of MB-seq> -f2
<format of RRBS> -i2 <input.list of RRBS> -g <reference> -o <outdir> [options]
====================================================================
Required parameters:
--------------------
	-f1  <str>   the format of input for MB-seq : cout/fq/sam/bam
	-i1  <str>   a list file of MB-seq, contains one or more deals (one
		     deal per line), which should match the -f1 parameter.
		(1)input.lib.list : a fastq list file with spaces delimited;
		     the gzip files are supported;for pared-end sequencing: 
		     fq1_path fq2_path min_insertsize max_insertsize; for sigle-end 
		     sequencing: fq1_path; and the list file can simultaneously 
		     contain SE and PE reads list;
		(2)sam.list: these SAM files should be the outputs of
		     bisulfite mapping software,such as BSMAP or SAAP
		(3)bam.list: these BAM files should be the outputs of
		     bisulfite mapping software,such as BSMAP or SAAP
		example:
		cout:
			MB_path/rep1.cout
			MB_path/rep2.cout
		fq:
			MB_path/rep1_read1.fq   MB_path/rep1_read2.fq 100  500
			MB_path/rep2_read.fq.gz
		sam:	
			MB_path/rep1.sam
			MB_path/rep2.sam
		bam:
			MB_path/rep1.bam
			MB_path/rep2.bam
	-f2  <str>   the format of input for RRBS: cout/fq/sam/bam
        -i2  <str>   a list file of RRBS, contains one or more deals (one deal
		     per line), which should match the -f2 paramete
		     r. (similar to i1)
                example:
                cout:
                        RRBS_path/rep1.cout
                        RRBS_path/rep2.cout
                fq:
                        RRBS_path/rep1_read1.fq   RRBS_path/rep1_read2.fq 40 300
                        RRBS_path/rep2_read.fq.gz
                sam:    
                        RRBS_path/rep1.sam
                        RRBS_path/rep2.sam
		bam:
                        MB_path/rep1.bam
                        MB_path/rep2.bam
	-g  <str>   genome reference (as a whole, fasta format), is required
		    when inputs contain fastq format.
	-c  <str>   Directory contains CpG information of genome.
	-e  <str>   Directory contains genomic elements. 

---------------------
optimized parameters:
---------------------

	-o  <str>   outputdir: expected to be absoulte path [default="./"]
	-t  <int>   number of processors to use [default=8].
	-v  <str>   verbose informations are retained, "yes" or "no". "yes" is
		    for debugging [default="no"].
	-x1 <tag>   remove potential PCR duplication for MB-seq when input
		    format is fq/sam/bam, default is omited.
	-x2 <tag>   remove potential PCR duplication for RRBS when input
		    format is fq/sam/bam, default is omited.
	-z  <int>   trim N end-repairing fill-in nucleotides for RRBS when
		    input format is fq/sam/bam [default=0].
	-h  <tag>   show this help information.
------------------------
parameters for fq input:
------------------------

	-u  <int>   if this value is between 0 and 1, it's interpreted as the
		    mismatch rate w.r.t to the read length.
                    otherwise it's interpreted as the maximum number of
		    mismatches allowed on a read, <=15.
                    example: -v 5 (max #mismatches = 5), -v 0.1 (max
		    #mismatches = read_length * 10%) [default=0.05].
	-q  <int>   quality threshold in trimming,0-40 [default=0] (no trim).
	-a  <str>   removed 3-end adapter sequence [default=none].
	-n  <int>   filter low-quality reads containing >n Ns [default=5].
	-w  <int>   set mapping strand information [default=0].
                    -w 0: only map to 2 forward strands, i.e. BSW(++) and
		    BSC(-+), 
                    for PE sequencing, map read#1 to ++ and -+, read#2 to +-
		    and --.
                    -w 1: map SE or PE reads to all 4 strands, i.e. ++, +-,
		    -+, -- 
	-m  <str>   set alignment information for the additional nucleotide
		    transition [default="TC"]. 
                    <str> is in the form of two different nucleotides N1N2, 
                    indicating N1 in the reads could be mapped to N2 in the
		    reference sequences.
                    default: -m TC, corresponds to C=>U(T) transition in
		    bisulfite conversion. 
                    example: -m GA could be used to detect A=>I(G) transition
		    in RNA editing. 
	-y  <str>   activating RRBS mapping mode and set restriction enzyme
		    digestion sites. digestion position marked by '-', 
		    example: -y C-CGG for MspI digestion [default="C-CGG"].

--------------------------
parameters for regression:
--------------------------
	-k  <str>   handle sampling of Ridge training, "half" or "random",
		    "half" means stably choosing the first half part of dataset 
		    while "random" means randomly choosing  half part of dataset 
		    [default="random"].
	-s  <flo>   value(s) of the penalty parameter lambda at which
                    predictions are required [default=0.06].
	-r  <flo>   values of alpha used in the fits,alpha=1 is the lasso
                    penalty, and alpha=0 the ridge penalty, otherwise 
		    (alpha>0 and alpha<1) is elastic net penalty [default=0].
	-d  <int>   depth threshold for RRBS covered sites [default=10].
	-p  <str>   pattern of C context (CG/CHG/CHH) [default="CG"].

=====================================================================
Example :
---------
./MBRidge -f1 cout -i1 MB.cout.list -f2 cout -i2 RRBS.cout.list -c /CpG-density-dir/ -e /element-bed-dir/ -o ./
./MBRidge -f1 fq -i1 MB.fq.list -f2 fq -i2 RRBS.fq.list -g hg19.fa -c /CpG-density-dir/ -e /element-bed-dir/ -o ~/MB/results/
./MBRidge -f1 fq -i1 MB.fq.list -f2 sam -i2 RRBS.sam.list -g hg19.fa -c /CpG-density-dir/ -e /element-bed-dir/ -o /Dir/MB/
./MBRidge -f1 bam -i1 MB.bam.list -f2 bam -i2 RRBS.bam.list -c /CpG-density-dir/ -e /element-bed-dir/ -o /Dir/MB/

4. Input and output format.

Input Format:

   cout:
"chr position strand C-pattern context mappability methy unmethy".
   1) chr: chromosome
   2) position: 1-offset position
   3) strand: +/-.
   4) C-pattern: CG/CHG/CHH, H presents C, A or T.
   5) context: context sequence of C (can be replaced by "." or something else).
   6) mappability: mappability of genome (can be replaced by "." or something else).
   7) methy: the number of reads that support methylation.
   8) unmethy: the number of reads that support unmethylation.

   fq:
http://en.wikipedia.org/wiki/FASTQ_format
   SAM/BAM:
http://samtools.github.io/hts-specs/SAMv1.pdf

Output 

   I. "MBRidge.results.final.all.xls".

   It is in the outdir/MBRidge_results/,each column means as:
"chr position strand RRBS-methy RRBS-depth RRBS-rate MB-methy MB-depth MB-rate MB_backMethyRate MB_backMethyGroup CGdensity GCcoutent  CGoe Type MBRidge-value"
   1) chr: chromosome
   2) position: 1-offset position
   3) strand: +/-.
   4) C-pattern: CG/CHG/CHH, H presents C, A or T.
   5) C-context: context sequence of C (can be replaced by ".").
   6) RRBS-methy: the number of reads that support methylation detected by RRBS.
   7) RRBS-depth: the number of reads for the locus detected by RRBS.
   8) RRBS-rate: the methylation level for the locus detected by RRBS.
   9) MB-methy: the number of reads that support methylation detected by MB-seq.
   10) MB-depth: the number of reads for the locus detected by MB-seq.
   11) MB-rate: the observed methylation level for the locus detected by MB-seq.
   12) MB_backMethyRate:  the mean observed methylation level around the locus detected by MB-seq.
   13) MB_backMethyGroup: the total observed methylated cytosines around the locus detected by MB-seq.
   14) CGdensity: CpG density around the locus.
   15) GCcontent: GC content around the locus.
   16) CGoe: CpG oe value around the locus.
   17) Type: type of prediction, in result of "Train" or "Test".
   18) MBRidge-value: the value of MBRidge prediction.

   II. "MBRidge.results.final.simple.xls".

   It is in the outdir/MBRidge_results/ and in consists of some columns of "MBRidge.results.final.all.xls", each column means as:
   1) chr: chromosome
   2) position: 1-offset position
   3) strand: +/-.
   4) C-pattern: CG/CHG/CHH, H presents C, A or T.
   5) RRBS-rate: the methylation level for the locus detected by RRBS.
   6) MBRidge-value: the value of MBRidge prediction.

   The Pearson correlation coefficient of each genomic feathure between RRBS and MBRidge is showed in the R STDERR file "Ridge.*.Rout".

5. Publication and contact.

   Publication: "Genome-wide profiling of DNA methylation at single-base resolution based on MeDIP-bisulfite high-throughput sequencing" (In submission).

6. Contact: 
   
   maofengbiao@gmail.com; caiwanshi@126.com

