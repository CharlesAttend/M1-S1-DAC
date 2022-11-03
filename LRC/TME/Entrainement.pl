% concatene(X, [], X).
% concatene(X, [T|Q], Z) :- concatene([T|X], Q, Z).
% concatene([T|Q], Y, Z) :- concatene(Q, [T|Y], Z).

% concatene([], [], Z) :- Z.
% concatene(X, [T|Q], Z) :- concatene(X, Q, [T|Z]).
% concatene([T|Q], [], Z) :- concatene(Q, [], [T|Z]).


% concatene([], X, X) :- writef("%t", [X]).
% concatene([T|Q], L, [T|L2]) :- writef("Q: %t, L: %t, L2: %t", [Q, L, L2]), nl, concatene(Q, L, L2).


concatene([], X, X).
concatene([T|Q], L, [T|L2]) :- concatene(Q, L, L2).

% Inverse : 
inverse([], []).
% inverse([T|Q], L2) :- inverse(Q, [T|L2]).
inverse([T|Q], L2) :- inverse(Q,L), concatene(L, [T], L2).

% Supprime : 
supprime([], _, []).
supprime([H|T], Y, [H|Z]) :- H\==Y, supprime(T, Y, Z), !.
supprime([_|T], Y, Z) :- supprime(T, Y, Z).

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
palindrome2(L1) :- concatene([T|Q], [T], L1),palindrome2(Q).