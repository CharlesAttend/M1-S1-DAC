pere(charles, david).
pere(david, claude).
pere(simon, david).
mere(charles, nathalie).
mere(simon, nathalie).
% parent(X,Y) :- pere(X,Y).
% parent(X,Y) :- mere(X,Y).
parent(X,Y,Z) :- pere(Z,X), mere(Z,Y).
grandpere(X,Y) :- pere(X,Z), pere(Z,Y).
frereOuSoeur(X,Y) :- pere(X,Z), pere(Y,Z).
frereOuSoeur(X,Y) :- mere(X,Z), mere(Y,Z).
