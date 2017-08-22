#---------Test---------
#MB is fq && RRBS is fq
dir=`pwd`
if [ ! -d "$dir/MBfq_RRBSfq_MBRidge" ];
then
	mkdir "$dir/MBfq_RRBSfq_MBRidge"
fi
cd $dir

echo "$dir/mb.1.fq.gz $dir/mb.2.fq.gz 100 500" > $dir/mb.fq.list

echo "$dir/rrbs.1.fq.gz $dir/rrbs.2.fq.gz 40 500" > $dir/rrbs.fq.list

cd $dir/MBfq_RRBSfq_MBRidge

$dir/../MBRidge -f1 fq -i1  $dir/mb.fq.list -f2 fq -i2 $dir/rrbs.fq.list -g $dir/ref.fa  -c  $dir/cpg -e $dir/bed -o $dir/MBfq_RRBSfq_MBRidge -k rand
