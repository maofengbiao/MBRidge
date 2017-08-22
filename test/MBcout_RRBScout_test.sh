#---------Test---------
#MB is cout && RRBS is cout
dir=`pwd`
if [ ! -d "$dir/MBcout_RRBScout_MBRidge" ];
then
	mkdir "$dir/MBcout_RRBScout_MBRidge"
fi
cd $dir
echo "$dir/mb.cout.gz" > $dir/mb.cout.list
echo "$dir/rrbs.cout.gz" > $dir/rrbs.cout.list

cd $dir/MBcout_RRBScout_MBRidge

$dir/../MBRidge -f1 cout -i1  $dir/mb.cout.list -f2 cout -i2 $dir/rrbs.cout.list -g $dir/ref.fa  -c  $dir/cpg -e $dir/bed -o $dir/MBcout_RRBScout_MBRidge -k rand -v
