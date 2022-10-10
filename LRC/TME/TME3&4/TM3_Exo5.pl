et(0,0,0).
et(0,1,0).
et(1,0,0).
et(1,1,1).

ou(0,0,0).
ou(0,1,1).
ou(1,0,1).
ou(1,1,1).

non(0,1).
non(1,0).

% nand(0,0,1).
% nand(0,1,1).
% nand(1,0,1).
% nand(1,1,0).
nand(X,Y,Z) :- et(X,Y,W), non(W,Z).

% xor(0,0,0).
% xor(0,1,1).
% xor(1,0,1).
% xor(1,1,0).
xor(X,Y,Z) :- ou(X,Y,W), non(W,V), et(W,V,Z).

circuit(X,Y,R) :- nand(X,Y,A), non(X,B), xor(A,B,C), non(C,R).
