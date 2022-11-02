%contatene(X,Y,Z) :- Z = [X|Y]. % Non il faut utiliser une récursion, voir photo du 10/10
concatene([], X, X).
concatene([T|Q], L, [T|L2]) :- concatene(Q, L, L2).

% Question 2
% inverse(X,X).
% inverse([T|Q], X) :- X = [Q | inverse(T,X)].
% inverse([T|Q], X) :- inverse([ Q | inverse(T,X) ], X). % Il faut utiliser concat d'après le prof
% inverse([T|Q], X) :- inverse([inverse(T,X)|Q], X).

% Correction 
% inverse([], []).
% inverse([X|L1], L2) :- inverse(L1, L), concatene(L, [X], L2).


% Question 3
% supprime([],X,Z).