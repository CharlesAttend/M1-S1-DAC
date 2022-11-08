% concatene(X, [], X).
% concatene(X, [T|Q], Z) :- concatene([T|X], Q, Z).
% concatene([T|Q], Y, Z) :- concatene(Q, [T|Y], Z).

% concatene([], [], Z) :- Z.
% concatene(X, [T|Q], Z) :- concatene(X, Q, [T|Z]).
% concatene([T|Q], [], Z) :- concatene(Q, [], [T|Z]).


% concatene([], X, X) :- writef("%t", [X]).
% concatene([T|Q], L, [T|L2]) :- writef("Q: %t, L: %t, L2: %t", [Q, L, L2]), nl, concatene(Q, L, L2).


concatene([], X, X).
concatene([H|T], Y, [H|Z]) :- concatene(T, Y, Z).

% Inverse : 
inverse([], []).
inverse([H|T], Z) :- inverse(T,L), concatene(L, [H], Z).
% inverse([T|Q], L2) :- inverse(Q, [T|L2]).

% Supprime : 
supprime([], _, []).
supprime([Y|T], Y, Z) :- supprime(T, Y, Z).
supprime([H|T], Y, [H|Z]) :- H\==Y, supprime(T, Y, Z).

% Filtre : 
filtre(X, [], X).
filtre(X, [H|T], Z) :- supprime(X, H, L), filtre(L, T, Z).

% Palindrome
palindrome(L) :- inverse(L, Z), Z==L.

% palindrome([]).
% palindrome2([H|T]) :- 
%     concatene([H], M, ),
%     concatene(L, H, L2),
%     .

palindrome2([_]).
palindrome2(X) :- concatene([H|T], [H], X), palindrome2(T).

% Annale 2019
appartient([], [], []).
appartient(H, [H|T], T) :- appartient().

permutation([],[]).
permutation(X,[Y|Z]) :- appartient(Y, X, L), permutation(L, Z).

