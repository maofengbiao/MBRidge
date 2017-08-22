#!/bin/bash
pwd_dir=`pwd`
cd $pwd_dir/tools/
echo ""
echo "============================================================================="
echo "Starting Installing MBRidge ...";
echo "============================================================================="
echo ""
echo "----installing BSMAP Start----"
rm -rf bsmap-2.74
tar zxfv bsmap-2.74.tgz
echo "$pwd_dir"
dir=$pwd_dir/tools/bsmap-2.74
echo "$dir"
cd $dir
make -C $dir
make install DESTDIR=$dir
ln -sf $pwd_dir/tools/bsmap-2.74/bsmap  $pwd_dir/tools
ln -sf $pwd_dir/tools/bsmap-2.74/samtools/samtools  $pwd_dir/tools
echo "----installing BSMAP Done----"
cd $pwd_dir
#R pkg
echo install R packages in $pwd_dir
cd "lib"
if [ -d "$pwd_dir/lib/R-packages" ]
        then
        echo "$pwd_dir/lib/R-packages exists"
        else
        mkdir "$pwd_dir/lib/R-packages"
fi
echo ""
echo "----installing MASS Start----"
R CMD INSTALL MASS_7.3-33.tar.gz -l $pwd_dir/lib/R-packages
echo ""
echo "----installing MASS Done----"
echo ""
echo "----installing Matrix & glmnet Start----"
for pkg in Matrix_1.1-4.tar.gz  glmnet_1.9-8.tar.gz;do
R CMD INSTALL $pkg  -l $pwd_dir/lib/R-packages
done
echo ""
echo "----installing Matrix & glmnet Done----"
echo ""
chmod 750 $pwd_dir/MBRidge
echo ""
echo "=============================================="
echo "Finished Installing MBRidge! Congratulations !";
echo "=============================================="
echo ""
exit
