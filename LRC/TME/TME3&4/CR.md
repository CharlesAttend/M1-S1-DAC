# TME1
## Exercice 1
Soit : 
- $S_1 : r(a,b).$
- $S_2 : r(f(X), Y) :- p(X,Y).$
- $S_3 : p(f(X), Y) :- r(X,Y).$
1) * $r(f(f(a)), b)$ :
    $$
    \begin{align*}
    R_1: r(f(f(a)), b) &\\
    R_2: p(f(a), b) &[Res : S_2, \{X\backslash f(a), Y \backslash b\}] \\
    R_3: r(a,b) &[Res : S_3, \{ X\backslash a, Y \backslash b\}] \\
    R_4: \top &[Res : S_3, \{ X\backslash a, Y \backslash b\}] \\
    \end{align*}
    $$
   * $p(f(a), b)$
    $$
    \begin{align*}
        R_1: p(f(a), b) & \\
        R_2: r(a,b) &[Res : S_3, \{ X\backslash a, Y \backslash b \}] \\
        R_3: \top &[Res : S_3, \{ X\backslash a, Y \backslash b \}] \\
    \end{align*}
    $$
2) Prolog nous remontre la démonstration dans les deux sens

## Exercice 2 
Soit : 
- $S_1 : r(a,b).$
- $S_2 : q(X, X).$
- $S_3 : q(X, Z) :- r(X,Y), q(Y,Z).$
1) * $q(X,b)$ :
    $$
    \begin{align*}
        R_1: q(X,b) &\\
        R_2: q(b,b) &[Res : S_2, \{X\backslash b \}] \\
        R_4: \top &[Res : S_2] \\
    \end{align*}
    $$
    Ou
    $$
    \begin{align*}
        R_1: q(X,b) &\\
        R_2: r(X,Y),q(Y,b) &[Res : S_3, \{X\backslash b \}] \\
        R_3: q(b,b) &[Res : \{X \backslash b, Y \backslash b\}] \\
        R_4: \top &[Res : S_2] \\
    \end{align*}
    $$
    ou
        $$
    \begin{align*}
        R_1: q(X,b) &\\
        R_2: r(X,Y),q(Y,b) &[Res : S_3, \{X\backslash b \}] \\
        R_3: q(b,b)         &[Res : \{Y \backslash b\}] \\
        R_4: r(b,Y), q(Y,b) &[Res : \{X \backslash b, Z \backslash b\}] \\
        R_4: \bot \text{A cause de }r(b,Y)      &[Res : S_2] \\
    \end{align*}
    $$
Voilà comment agis prolog, il explore chaque possibilité dans l'ordre.

## Exercice 3
Je passe il faut que je rattrape mon retard, je suis à la 4ème séance de TME.

## Exercice 4
1) pere(charles, david).
    mere(charles, nathalie).
2) parent(X,Y) :- pere(X,Y).
    parent(X,Y) :- mere(X,Y).
3)  `parent(charles,X).
    X = david ;
    X = nathalie.`
4) `?- parent(david,nathalie,charles).
    true.
    ?- parent(david,nathalie,X).
    X = charles.`
5) `?- grandpere(charles, claude).
    true.
    ?- grandpere(X, claude).
    X = charles ;
    X = simon.`
6) L'ordre des paramètre est important 

## Excercice 5
1) Voir le code `exo5.pl`
2) 
4) `circuit(X,Y,1).` 
   `circuit(X,Y,0).`

# TME2
# Exercice 1
