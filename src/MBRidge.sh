
perl  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/bin/mb-methylback.pl  -i /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/Methyrate_MB/MB-seq.combined.cout -m /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/Methyrate_MB/MB-seq.combined.cout -o /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/MB.backmethy -d 0 -s 201
perl /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/bin/join_couts_backmethy_cpgdens.pl -d0 /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/Methyrate_MB/MB-seq.combined.cout  -d1 /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/Methyrate_RRBS/RRBS.combined.cout  -d2 /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/cpg/\*.CG.density -d3 /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/MB.backmethy -o  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all.MBRidge.input  
awk '{if($3=="+"){print $1"\t"$2"\t"$3"\t"$16"\t"$16+$17"\t"$18"\t"$7"\t"$7+$8"\t"$9"\t"$19"\t"$20"\t"$21"\t"$22"\t"$23}}'  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all.MBRidge.input > /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all.MBRidge.input.format
sort -k 1,1 -k 2,2n  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all.MBRidge.input.format  -o /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all.MBRidge.input.format

awk '{if($5>=10 && $4!~/NA/){print $0}}' /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all.MBRidge.input.format > /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/MBRidge.input.format

#elements (RRBS>=10,contain MB-seq=zero)
mkdir -p /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element;
perl /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/bin/overlap_region.pl  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/MBRidge.input.format  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/bed/\*.sorted.bed  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element
perl /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/bin/other_feature.pl -a /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/MBRidge.input.format -i /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/ele\*.input  -o  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/other.input
mv /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/other.input  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/ele.other.input

#elements (RRBS>=0,all)

mkdir -p /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all_in_element;
perl /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/bin/overlap_region.pl  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all.MBRidge.input.format  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/bed/\*.sorted.bed  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all_in_element
perl /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/bin/other_feature.pl -a /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all.MBRidge.input -i /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all_in_element/ele\*.input  -o  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all_in_element/other.input
mv /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all_in_element/other.input  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all_in_element/ele.other.input

ls /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/ele*.input  | awk -F "[/.]" '{print $(NF-1)}' > /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/element.list

#regression and evaluation

for i in `cat /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/element.list`;do
#mkdir -p  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/$i
perl /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/bin/allminusmodel.pl   -i /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/ele.$i.input  -a /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all_in_element/ele.$i.input -o /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/ridge.$i.tst
perl /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/bin/MBRidge.regression.pl -m /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/ele.$i.input -t /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/ridge.$i.tst -h $handle -s $s -a 0 -o /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/  -n $i 
done
perl /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/bin/average_outlier.methy.pl -i /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/element/ele\*.regression.result.xls -o /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/average.regression.xls
perl /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/bin/reform_combine.pl  -i /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/average.regression.xls -a  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/all.MBRidge.input.format -t  /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MB_combined_RRBS/MBRidge.input.format   > /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MBRidge_results/MBRidge.regression.final.all.xls
#sort -k 1,1 -k 2,2n /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MBRidge_results/MBRidge.regression.final.all.xls -o /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/MBRidge_results/MBRidge.regression.final.all.xls

