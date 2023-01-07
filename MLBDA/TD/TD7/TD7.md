Arbre DOM :
- Base
    - Restaurant : IDREF:@nom, @etoile, @ville
        - Fermeture : txt
        - menu : @nom, @prix
        - menu : @nom, @prix
        - menu : @nom, @prix
    - Ville : ID:@nom, @departement
        - plusBeauMonument : @nom, @tarif 

# Exercice 1 : 
## Moi
1) `//menu[@prix < 50]`
2) `//restaurant[@etoile = 2 | @etoile = 2]`
3) `//vile[@departement = 69]/@nom`
4) ->`//restaurant[@ville/@nom = "Lyon"]/@nom`
5) ->`//restaurant[@ville/@departement = "75"]`
6) `/base/ville[@nom = count(//restaurant[@ville = ? and @etoile = 3]) >= 1]/plusBeauMonument`
7) `//ville[@nom = //restaurant/@ville[count(./menu) >= 4]]`
8) `//restaurant[@etoile = 3 and fermeture = "dimanche"]`
9) //restaurants[count(menu/@nom = @ville) > 0]
10) 
    a) `//restaurant[count(menu/@nom = @ville) > 0 and position(/menu) = 2]`
    b) `//menu[position() = 5]`
11)  `//restaurant[@ville = //ville[3]/@nom]/@etoile`
12)  
    a) `//restaurant/@menu[@prix < 150][2]`
    b) `//restaurant/@menu[2][@prix < 150]`
13) Les restaurants ouvert Lundi : 
14) `//ville[@nom = //restaurant/@ville[not(etoile = 3)]]` ?
15) 
    a) `//vile[count(plusBeauMonument) = 0]`
    b) `//restaurant[@ville = //ville[count(plusBeauMonument) = 0]/@nom`
16) `//restaurant[menu/@prix < min(//restaurant[@nom = "Les quatres saisons"]/menu/@prix)]` mais y'a pas de min lol
17) 


## Correction
1) `/base/restaurant/menu[@prix < 50>] ` ou `//menu[@prix < 50]`
2) `//restaurant[@etoile = 2 or @etoile = 3]`
3) `//vile[@departement = 69]/@nom`
4) -> `//restaurant[@ville="Lyon"]/@nom`
5) -> `//restaurant[@ville = //ville[@departement = 75]/@nom]/@nom`
6) -> `//ville[@nom = //restaurant[@etoile=3]/@ville]`
7) -> Pas de `./` : `//ville[@nom = //restaurant/@ville[count(menu) >= 4]]`
8) -> Use `contain` : `//restaurant[@etoile = 3 and contain(fermeture, "dimanche")]`
9) -> Use `contain` : `//restaurant[contains(menu/@nom, @ville)]` mais si il y a plusieurs menu il est pas sur du comportement de contain donc pour être sur on fait `//restaurant[menu[contain(@nom, ../@ville)]]`
10) 
    a) Missuse of `position` : `//restaurant/menu[2]`
    b) Pas de `//` ça fait qu'on fait le 5 ème menu par son parent `Restaurant` il ne faut pas utiliser le raccourcis `//`, c'est quand on traduit le `//menu`=`/restaurant/menu`: `/descendant::menu[5]`
11)  C'est bon mais attention quand y'a un ordre, il vaut mieux ne pas utiliser `//`, ici ça marche comme on part de la racine
12)
    a) Attention assez subtile, je prends le deuxième menu parmis ceux à moins de 150€  
    b) Ok
13)  `//restaurant[not(contain(fermeture, "lundi"))]`
14)  `//ville[not(@nom=//restaurant[@etoile=3])]/@ville`
15)  
    a) OK + autre solution : `//ville[not(PlusBeauMonument)]`
    b) OK + autre solution `//restaurant[@ville = //ville[not(PlusBeauMonument)]`
16) Je retourne un restaurant s'il n'existe pas de menu plus : `//restaurant[not(menu/@prix > //restaurant[@nom="Les Quatre Saisons"]/menu/@prix)]` (je sais pas pourquoi il met un not)
17) Ca devient le bordel même le prof aime pas, il dit qu'il vaut mieux utiliser XQuery pour ce genre de requête : `//ville[@nom = //restaurant[@etoile=3 and @ville=following::restaurant[@etoile=3]/@ville]/@ville`
18) `//restaurant[menu[contains(@nom, 'salade')]/@prix != menu[contains(@nom, 'solde)]/@prix]/@nom`
19) Possible
20) On peut pas faire sans XQuery 


