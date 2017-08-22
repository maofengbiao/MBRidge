echo "--------------------------------------------" >&2 ;echo "Project starts: `date`"  >&2;echo "--------------------------------------------" >&2 ;
echo "---step [combine couts of MB-seq] starts-->: `date`"  >&2 
if
	perl /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/bin/parawork.pl /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/shell/combine_cout_mb.sh /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test 1 	
then
        echo "---step [combine couts of MB-seq] done-->: `date`" >&2 
else
        echo "---step [combine couts of MB-seq] ERROR-->" >&2 
        exit
fi

echo "---step [combine couts of RRBS] starts-->: `date`"   >&2
if
        perl /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/bin/parawork.pl /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/shell/combine_cout_rrbs.sh /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test 1        
then
        echo "---step [combine couts of RRBS] done-->: `date`"   >&2
else
        echo "---step [combine couts of RRBS] ERROR-->"   >&2
        exit
fi

echo "---step [MBRidge Regression] starts-->: `date`"   >&2
if
        bash /panfs/home/VIP/maofb/MB/cosmos/MBRidge-pipe/test/shell/MBRidge.sh
then
        echo "---step [MBRidge Regression] done-->: `date`"   >&2
else
        echo "---step [MBRidge Regression] ERROR-->"   >&2
        exit
fi
echo "--------------------------------------------" >&2 ;echo "Project ends: `date`"  >&2;echo "--------------------------------------------" >&2 ;
