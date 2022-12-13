#!/bin/sh

# making trainsX.c

out=trains$1.c
echo "" > $out
echo "/* number of trains: (N>0) */" >> $out
echo "#define N $1" >> $out
cat trainsbase.c >> $out

# list of transitions
T=\"{D1.1}\",\"{D2.1}\",\"{U.1}\"
# transition index
K=3
# subnet index
I=2
J=`(echo "$1+1" | bc)`
while (test $I -le $J)
do 
echo "value act_$K (value s) {return s+1;}" >> $out
K=`(echo "$K+1" | bc)`
echo "value act_$K (value s) {return s-1;}" >> $out
K=`(echo "$K+1" | bc)`
T=${T},\"{App.${I}}\",\"{Ex.${I}}\"
I=`(echo "$I+1" | bc)`
done

echo "" >> $out
echo "/* transitions table: */" >> $out
T="{"$T"}"
echo "" >> $out
echo "char *transtable[$K]=${T};" >> $out
echo "" >> $out
echo "char **transitions (int *sz) {*sz = $K; return transtable;}" >> $out


# making trainsX.tpn
out=trains$1.tpn
echo "load barrier.ndr" > $out
echo "load train.ndr" >> $out
I=1
while (test $I -lt $1)
do
echo "dup" >> $out
I=`(echo "$I+1" | bc)`
done
I=`(echo "$1+1" | bc)`
echo "merge $I" >> $out




