cd /panfs/home/VIP/maofb/MB/cosmos/regression/t29h
perl /panfs/home/VIP/maofb/MB/cosmos/regression/Multivariable/MB2-BS/join_methy_for_two_samples.pl  -d1 /panfs/home/VIP/maofb/MB/cosmos/regression/t29h/sigle-strand/chr\*.cout -d2  /panfs/home/VIP/maofb/MB/cosmos/regression/t29h/rrbs/chr\*.cout  -o mb2-rrbs-CG.xls -p  CG -f1  0 -f2 10
perl  /panfs/home/VIP/maofb/MB/cosmos/regression/Multivariable/MB2S8-RRBS/dep10/combine/join_methy_for_two_samples_add_cpgdens.pl   -d1  mb2-rrbs-CG.xls -d2 /panfs/home/VIP/maofb/database/human/hg18/CGdensity/new/\*.density -o  all-continuous.join.final.xls -d3  /panfs/home/VIP/maofb/MB/cosmos/regression/t29h/sigle-strand/backmethy/\*.backmethy -c 20000
sort -k 1,1 -k 2,2n  all-continuous.join.final.xls  -o all-continuous.join.final-sorted.xls
awk '{if($3=="+"){print $1"\t"$2"\t"$3"\t"$20"\t"$7"\t"$7+$8"\t"$19"\t"$21"\t"$22"\t"$23"\t"$24"\t"$25}}'  all-continuous.join.final-sorted.xls > all-continuous.join.final-sorted-input.xls
awk '$1=="chr10"' all-continuous.join.final-sorted-input.xls > all-continuous.join.final-sorted-input-chr10.xls
#RRBSrate->MBmethy->MBdepth->MBrate->backmethyRate->backmethygroup->CGdensity->GCcontent->CGoe
#continuous --> backmethy is continuous for MB level.  -f1  0 
