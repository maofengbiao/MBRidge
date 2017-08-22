#---------Test---------
#MB is cout && RRBS is fq
dir=`pwd`
if [ ! -d "$dir/MBcout_RRBSfq_MBRidge" ];
then
	mkdir "$dir/MBcout_RRBSfq_MBRidge"
fi
cd $dir
echo "$dir/mb.cout.gz" > $dir/mb.cout.list
echo "$dir/rrbs.1.fq.gz $dir/rrbs.2.fq.gz 40 500" > $dir/rrbs.fq.list

cd $dir/MBcout_RRBSfq_MBRidge

$dir/../MBRidge -f1 cout -i1  $dir/mb.cout.list -f2 fq -i2 $dir/rrbs.fq.list -g $dir/ref.fa  -c  $dir/cpg -e $dir/bed -o $dir/MBcout_RRBSfq_MBRidge -k rand
