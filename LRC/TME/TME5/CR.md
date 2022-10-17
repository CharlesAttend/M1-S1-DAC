# CR - TME 5
# Exercice 1 
- `subs(chat,felin).` $ chat \sqsubseteq felin $ Les chats sont des felins
- `subs(chihuahua,and(chien,pet)).` $ chihuahua \sqsubseteq chien \wedge pet$ Un chihuahua est à la fois un chien et un animal de compagnie
- `subs(and(animal,some(aMaitre)),pet).` $ animal \wedge \exist aMaitre \sqsubseteq pet$ Un animal qui a un maˆıtre est un animal de compagnie
- `subs(some(aMaitre),all(aMaitre,personne)).` $ \exist aMaitre \sqsubseteq \forall aMaitre.personne$  Toute entité qui a maître ne peut avoir qu’un (ou plusieurs) maître(s) humain(s)
- `subs(and(all(mange,nothing),some(mange)),nothing).` $ \forall mange.\bot \wedge \exist mange \sqsubseteq \bot$ On ne peut pas à la fois ne rien manger (ne manger que des choses qui n’existent pas) et manger quelque chose.
- `equiv(carnivoreExc,all(mange,animal)).` $carnivoreExc \equiv \forall mange.animal$ Un carnivore exclusif est défini comme une entité qui mange uniquement des animaux

## Excercice 2
### Question 1 
- `subsS1(C,C).` traduit l'égalité de l'inclusion $\sqsubseteq$
- `subsS1(C,D):-subs(C,D),C\==D.` traduit l'inclusion sans égalité $\sqsubset$
- `subsS1(C,D):-subs(C,E),subsS1(E,D).` traduit le fait qu'il faut fouiller dans chaque subs, en passant par une récursion.
```
?- subsS1(canari, animal).
true ;
true ;
false.

?- subsS1(chat,etreVivant).
true ;
true ;
false.
```
La récursion fonctionne bien.

### Question 2
```
?- subsS1(chien,souris).
false.
```
Cette requête provoque une boucle infini. Prolog fait 
- Chien - canidé - mamifaire - etreVivant => X donc ça reboucle pour chercher un autre chemin
- Chien - canidé - chien => La boucle est bouclé

### Question 3
La trace est grande. On voit que la liste de variable déjà checké augmente bien.

### Question 4
`subsS(souris, some(mange)). true`  il passe par $ souris \sqsubset animal \sqsubset \exist mange$. 

### Question 5
`subsS(chat, X).` devrait renvoyé tous les parents de chat, en remontant l'arbre. 
```prolog
?- subsS(chat, X).
X = chat ;
X = felin ;
X = mammifere ;
X = animal ;
X = etreVivant ;
X = some(mange) ;
false.
```
`subsS(X, mammifere).` devrait renvoyé tous les enfants de mammifère, en descendant l'arbre. 
```prolog
?- subsS(X, mammifere).
X = mammifere ;
X = felin ;
X = canide ;
X = souris ;
X = chat ;
X = chien ;
X = lion ;
false.
```

### Question 6
Avant l'ajout des règles d'équivalence.
```prolog
?- subsS(lion, all(mange,animal)).
false.
```
Après l'ajout des règle suivante :
```prolog
subs(C,D) :- equiv(C,D).
subs(D,C) :- equiv(C,D).
```

```prolog
?- subsS(lion, all(mange,animal)).
true ;
true ;
true ;
true ;
true ;
true ;
true ;
true ;
false.
```
Je ne sais pas trop ce qu'il fait, d'après le prof, on ne l'a pas assez limité dans sa recherche, du coup il trouve plusieurs chemin possible. 