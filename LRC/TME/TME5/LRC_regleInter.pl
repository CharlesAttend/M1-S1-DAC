/* Règles de l'exo 3. à recopier à la suite des règles de l'exo 2 dans le fichier LRC_tme5.pl */
subsS(C,and(D1,D2),L):-D1\=D2,subsS(C,D1,L),subsS(C,D2,L).
subsS(C,D,L):-subs(and(D1,D2),D),E=and(D1,D2),not(member(E,L)), subsS(C,E,[E|L]),E\==C.
subsS(and(C,C),D,L):-nonvar(C),subsS(C,D,[C|L]).
subsS(and(C1,C2),D,L):-C1\=C2,subsS(C1,D,[C1|L]).
subsS(and(C1,C2),D,L):-C1\=C2,subsS(C2,D,[C2|L]).
subsS(and(C1,C2),D,L):-subs(C1,E1),E=and(E1,C2),not(member(E,L)),subsS(E,D,[E|L]),E\==D.
subsS(and(C1,C2),D,L):-Cinv=and(C2,C1),not(member(Cinv,L)),subsS(Cinv,D,[Cinv|L]).
