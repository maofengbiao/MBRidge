#---------Test---------
#MB is fq && RRBS is cout
dir=`pwd`
if [ ! -d "$dir/MBfq_RRBScout_MBRidge" ];
then
	mkdir "$dir/MBfq_RRBScout_MBRidge"
fi
cd $dir

echo "$dir/mb.1.fq.gz $dir/mb.2.fq.gz 100 500" > $dir/mb.fq.list

echo "$dir/rrbs.cout.gz" > $dir/rrbs.cout.list

cd $dir/MBfq_RRBScout_MBRidge

$dir/../MBRidge -f1 fq -i1  $dir/mb.fq.list -f2 cout -i2 $dir/rrbs.cout.list -g $dir/ref.fa  -c  $dir/cpg -e $dir/bed -o $dir/MBfq_RRBScout_MBRidge -k rand
