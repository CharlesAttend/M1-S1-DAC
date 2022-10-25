% Pour le linter qui casse les pieds
:- dynamic cnamen/1.
:- dynamic cnamena/1.
:- dynamic iname/1.
:- dynamic rname/1.
:- discontiguous verif_Concept/1.

% Vérification sémantique : 
% Prédicat "Alphabet"
verif_Concept(C) :- cnamea(C), !. % Vérification des concepts atomique
verif_Concept(CG) :- cnamena(CG), !. % Vérification des concepts non atomique
verif_Instance(I) :- iname(I), !. % Vérification des identificateurs d'instance
verif_Role(R) :- rname(R), !. % Vérification des identificateurs de rôle.

% On vérifie la grammaire de la logique ALC (sujet I.3)
verif_Concept(not(C)) :- verif_Concept(C), !.
verif_Concept(and(C1, C2)) :- verif_Concept(C1), verif_Concept(C2), !.
verif_Concept(or(C1, C2)) :- verif_Concept(C1), verif_Concept(C2), !.
verif_Concept(some(R, C)) :- verif_Role(R), verif_Concept(C), !.
verif_Concept(all(R, C)) :- verif_Role(R), verif_Concept(C), !.

% Vérification syntaxique
% Pour la Tbox
verif_Equiv(CA, CG) :- verif_Concept(CA), verif_Concept(CG), !.

autoref(NomC, and(ExpC1, ExpC2)) :- autoref(NomC, ExpC1), autoref(NomC, ExpC2).
autoref(NomC, some(_, ExpC)) :- autoref(NomC, ExpC).
autoref(NomC, all(_, ExpC)) :- autoref(NomC, ExpC).
autoref(NomC, ExpC) :- 
    NomC \== ExpC,
    writef("NomC %t, ExpC: %t, Exp: X", [NomC, ExpC]), nl, 
    equiv(ExpC, Exp),
    writef("NomC %t, ExpC: %t, Exp: %t", [NomC, ExpC, Exp]), nl, 
    autoref(NomC, Exp). % Si on tombe sur un terme qui a une definition d'équivalence, alors on remplace la definiton
autoref(NomC, ExpC) :- NomC \== ExpC, !.


verif_Tbox([(CA, CG) | Q]) :- 
    verif_Concept(anything), 
    verif_Concept(nothing), 
    verif_Equiv(CA, CG), 
    autoref(CA, CG),
    verif_Tbox(Q).
verif_Tbox([]).

% Pour la Abox
verif_Inst(I, CG) :- verif_Instance(I), verif_Concept(CG), !.
verif_InstR(I1, I2, R) :- verif_Instance(I1), verif_Instance(I2), verif_Role(R), !.

verif_AboxC([]).
verif_AboxC([(I, CG) | Q]) :- verif_Inst(I, CG), verif_AboxC(Q), !.

verif_AboxR([]).
verif_AboxR([(I1, I2, R) | Q]) :- verif_InstR(I1, I2, R), verif_AboxR(Q), !.

verif_Abox([AboxC | AboxR]) :- verif_AboxC(AboxC), verif_AboxR(AboxR), !.