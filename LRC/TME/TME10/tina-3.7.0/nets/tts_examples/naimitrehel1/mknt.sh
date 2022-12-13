#!/bin/sh

# making ntX.c
out=nt$1.c
echo "" > $out
echo "/* number of sites: (N>0) */" >> $out
echo "#define N $1" >> $out

cat ntbase.c >> $out

# list of transitions
T=
# number of transitions
K=0

I=1
while (test $I -le $1)
do 
echo "bool pre_$K (key s) {return pre_request_x($I,s);}" >> $out
echo "key  act_$K (key s) {return act_request_x($I,s);}" >> $out
if test $K -ne 0
then
T=${T},\"request_${I}\"
else
T=${T}\"request_${I}\"
fi
K=`(echo "$K+1" | bc)`
J=1
while (test $J -le $1)
do
if test $I -ne $J
then
echo "
bool pre_$K (key s) {return pre_transit_x_y($I,$J,s);}
key  act_$K (key s) {return act_transit_x_y($I,$J,s);}" >> $out
T=${T},\"transit_${I}_${J}\"
K=`(echo "$K+1" | bc)`
echo "
bool pre_$K (key s) {return pre_ok_x_y($I,$J,s);}
key  act_$K (key s) {return act_ok_x_y($I,$J,s);}" >> $out
T=${T},\"ok_${I}_${J}\"
K=`(echo "$K+1" | bc)`
fi
J=`(echo "$J+1" | bc)`
done
echo "
bool pre_$K (key s) {return pre_ack_x($I,s);}
key  act_$K (key s) {return act_ack_x($I,s);}
" >> $out
T=${T},\"ack_${I}\"
K=`(echo "$K+1" | bc)`
I=`(echo "$I+1" | bc)`
done
T="{"$T"}"
echo "char *transtable[$K]=${T};" >> $out
echo "char **transitions (int *sz) {*sz = $K; return transtable;}" >> $out

# making ntX.net
out=nt$1.net
echo "" > $out
echo "net {NT $1}" >> $out
I=1
while (test $I -le $1)
do
echo "pl idle_$I (1)" >> $out
echo "tr request_$I idle_$I -> wait$I" >> $out
J=1
while (test $J -le $1)
do
if test $I -ne $J
then
echo "tr transit_${I}_${J} idle_$I -> idle_$I" >> $out
echo "tr ok_${I}_${J} idle_$I -> idle_$I" >> $out
fi
J=`(echo "$J+1" | bc)`
done
echo "tr ack_$I wait$I -> cs$I" >> $out
echo "tr lib_$I cs$I -> idle_$I" >> $out
I=`(echo "$I+1" | bc)`
done
echo "" >> $out

# making ntX.ltl
out=nt$1.ltl
echo "" > $out
echo -n "[](cs1" >> $out
I=2
while (test $I -le $1)
do
echo -n "*cs$I" >> $out
I=`(echo "$I+1" | bc)`
done
echo "=0);" >> $out
echo "" >> $out
echo "[](wait1 => <> cs1);" >> $out
echo "" >> $out


