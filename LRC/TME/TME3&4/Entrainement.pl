% concatene(X, [], X).
% concatene(X, [T|Q], Z) :- concatene([T|X], Q, Z).
% concatene([T|Q], Y, Z) :- concatene(Q, [T|Y], Z).

% concatene([], [], Z) :- Z.
% concatene(X, [T|Q], Z) :- concatene(X, Q, [T|Z]).
% concatene([T|Q], [], Z) :- concatene(Q, [], [T|Z]).


concatene([], X, X) :- writef("%t", [X]).
concatene([T|Q], L, [T|L2]) :- writef("Q: %t, L: %t, L2: %t", [Q, L, L2]), nl, concatene(Q, L, L2).


concatene([], X, X).
concatene([T|Q], L, [T|L2]) :- concatene(Q, L, L2).