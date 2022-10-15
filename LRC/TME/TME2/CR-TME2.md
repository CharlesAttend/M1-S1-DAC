# Compte Rendu LRC-TME-2, VIN Charles
Durant cette séance de TME, nous avons appris à utiliser LoTERC, un logiciel qui automatise la méthode des tableaux. Par le biais de l'exercice deux, on a compris comment utiliser le logiciel pour vérifier un raisonnement logique. On utilise notamment une preuve par contraposé. Dans le dernier exercice, nous avons appris à interpréter les pré-modèle (feuille du tableau) afin de trouver les solution à la formule.

# Réponse aux questions étoilées:
## Exercice 2 : Question 1
On connaît la satisfiabilitée avec les règles suivantes :
- Si l'arbre contient une feuille ouverte, alors $\mathcal{F}$ est satisfiable
- Si toutes les feuilles de l'arbre sont fermées, alors $\mathcal{F}$ est insatisfiable
- Pour vérifier la validité, on regarde la satisfiabilité de $\lnot \mathcal{F}$, si c'est insatisfiable, cela veut dire que $\mathcal{F}$ est valide.
1) `and A not imp B A` ; Insatisfiable
2) `imp and or A C or B C imp not B or and A B C` ; Valide
3) `not imp imp A B imp not B not A` ; Insatisfiable
4) `or and imp A B imp B C and imp C B imp B A` ; Satisfiable
5) `imp imp A B equiv imp B C imp A C` ; Satisfiable
6) `imp and imp A B imp B C imp A C` ; Valide
	
## Exercice 3 : Question 3
On remplace $$\varphi_3 = FIEVRE \wedge TOUX \to GRIPPE$$ par $$\varphi_3 = FIEVRE \wedge TOUX \to GRIPPE \vee BRONCHITE$$
La seule branche ouverte est celle ou $BRONCHITE$ est vrais.

## Exercice 4
### Question 3
La formule suivante $$ A \vee (A \wedge B) \vee (A \wedge B \wedge C)$$ donne trois pré-modèles $(A,B,C)$: 
- $(1,B,C)$
- $(1,B,1)$
- $(1,1,1)$

On peut donc déduire trois modèles inclus les un dans les autres :
- $M(P_3) = \{ \{(1,0,1)\}, \{(1,0,0)\}, \{(1,1,1)\}, \{(1,1,0)\}, \}$
- $M(P_2) = \{ \{(1,0,1)\}, \{(1,1,1)\} \}$
- $M(P_1) = \{ \{(1,1,1)\}, \}$

On a bien $$M(P_1)\subset M(P_2) \subset M(P_3)$$

### Question 4
Non, justement à cause de cette inclusion possible. Un pré-modèle peut donner un à plusieurs modèles. Il faut compter plus précisément les atomes de chaque pré-modèle pour pouvoir le prédire. 