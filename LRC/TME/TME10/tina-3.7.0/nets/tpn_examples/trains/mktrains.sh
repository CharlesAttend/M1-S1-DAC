#!/bin/sh

# usage: mktrains n
#  or    mktrains n | build
#  or    mktrains n | build > trainsn.net
#  or    mktrains n | build | tina -s 0 -q


echo "# train"
echo "new"
echo "tr App Far -> Close"
echo "tr Ex [2,4] On -> Left"
echo "tr Exit [0,0] Left -> Far"
echo "tr In [3,5] Close -> On"
echo "pl Far (1)"
echo "lb App App"
echo "lb Exit Exit"
I=$1
while (test $I -gt 1)
do echo "dup"
   I=`(echo "$I-1" | bc)`
done
echo "merge $1"


# d = n-1
N=$1
D=`(echo "$N-1" | bc)`

echo "# controler"
echo "new"
echo "tr A1 far*$N -> Coming far*$D in"
echo "tr A2 far in -> in*$D"
echo "tr D [0,0] Coming ->"
echo "tr E1 [0,0] far*$D in -> Leaving far*$N"
echo "tr E2 [0,0] in*$D -> far in"
echo "tr U [0,0] Leaving ->"
echo "pl far ($N)"
echo "lb A1 App"
echo "lb A2 App"
echo "lb E1 Exit"
echo "lb E2 Exit"
echo "lb D Down"
echo "lb U Up"

echo "# barrier"
echo "new"
echo "tr D1 [0,0] Up -> lowering"
echo "tr D2 [0,0] raising -> lowering"
echo "tr L [1,2] lowering -> Down"
echo "tr R [1,2] raising -> Up"
echo "tr U [0,0] Down -> raising"
echo "pl Up (1)"
echo "lb D1 Down"
echo "lb D2 Down"
echo "lb U Up"

echo "sync 3"


