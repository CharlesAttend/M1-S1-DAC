#!/bin/sh

# usage: mkcontroler n

# d = n-1
N=$1
D=`(echo "$N-1" | bc)`

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
