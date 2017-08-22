perl  mb-methylback.pl  -i <MB-cout>  -m  <MB-cout>  -o <MB-backmethy.output> -d <depth> -s <window_size>
perl join_cout_for_two_methods.pl -d1 <MB2 cout> -d2 <RRBS cout> -p <C_pattern> -f1 <MB_depth>[0] -f2 <RRBS_depth>[10]  -o <RRBS-MB.combine.cout>
perl join_couts_backmethy_cpgdens.pl -d1  <RRBS-MB.combine.cout> -d2 <CpG density files> -d3 <MB-backmethy.output> -o   <RRBS-MB.combine.cout.add.CpGdense.backmethy>
perl select_MBdep_zero.pl <RRBS-MB.combine.cout.add.CpGdense.backmethy> <MBRidge.input> 
perl overlap_region.pl  <RRBS-MB.combine.cout.add.CpGdense.backmethy> <gene region file>
perl MBRidge.randomhalf.training.regression.pl ...
perl MBRidge.randomhalf.evaluation.pl ...
perl combine.methy.pl ..
perl average.methy.pl ..
