/*Exo 2*/
/* T-BOX */
subs(chat,felin).                                    /* ligne 3 */
subs(felin,mammifere).
subs(mammifere,animal).
subs(canide,mammifere).
subs(chien,canide).
subs(canide,chien).
subs(canari,animal).
subs(animal,etreVivant).
subs(lion,felin).
subs(lion,carnivoreExc).
subs(carnivoreExc,predateur).
subs(chihuahua,and(chien,pet)).                      /* ligne 14 */
subs(souris,mammifere).
subs(and(animal,some(aMaitre)),pet).                 /* ligne 16 */
subs(pet,some(aMaitre)).
subs(animal,some(mange)).
subs(some(aMaitre),all(aMaitre,personne)).           /* ligne 19 */
subs(and(animal,plante),nothing).
subs(and(all(mange,nothing),some(mange)),nothing).   /* ligne 21 */
equiv(carnivoreExc,all(mange,animal)).               /* ligne 22 */
equiv(herbivoreExc,all(mange,plante)).

subs(C,D) :- equiv(C,D).
subs(D,C) :- equiv(C,D).

subsS(C,D) :- subsS(C,D,[C]).
subsS(C,C,_).
subsS(C,D,_):-subs(C,D),C\==D.
subsS(C,D,L):-subs(C,E),not(member(E,L)),subsS(E,D,[E|L]),E\==D.

% equivS(C,D) :- subsS(C,D).
% equivS(C,D) :- subsS(D,C).

/* Règles de l'exo 3. à recopier à la suite des règles de l'exo 2 dans le fichier LRC_tme5.pl */
subsS(C,and(D1,D2),L) :- D1\=D2, subsS(C, D1, L), subsS(C, D2, L).
subsS(C, D, L) :- subs(and(D1, D2), D), E=and(D1, D2), not(member(E, L)),  subsS(C, E, [E|L]), E\==C.
subsS(and(C, C), D, L) :- nonvar(C), subsS(C, D, [C|L]).
subsS(and(C1, C2), D, L) :- C1\=C2, subsS(C1, D, [C1|L]).
subsS(and(C1, C2), D, L) :- C1\=C2, subsS(C2, D, [C2|L]).
subsS(and(C1, C2), D, L) :- subs(C1, E1), E=and(E1, C2), not(member(E, L)), subsS(E, D, [E|L]), E\==D.
subsS(and(C1, C2), D, L) :- Cinv=and(C2, C1), not(member(Cinv, L)), subsS(Cinv, D, [Cinv|L]).

% Exercice 4 
subsS(C,D, L) :- subsS(all(R,C), all(R,D), L), E=all(R,D), not(member(E,L)), subsS(E, D, [E|L]).
% subsS(all(R,C), all(R,D), L) :- subsS(C,D, [|L]).
% subsS(C,D, L) :- subsS(C, all(R,D), L).
% subsS(C, all(R,D), L) :- subsS(C,D, L).
% subsS(all(R,C), D, L) :- subsS(and()).