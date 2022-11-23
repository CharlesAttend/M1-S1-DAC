(: ctrl + k pour commenter :) 

(: 1 :)
(: //FILM/TITRE :)

(: 2 :)
(: //FILM[GENRE = "Horreur"]/TITRE :)

(: 3 :)
(: //FILM[TITRE = "Alien"]/RESUME :)

(: 4 :)
(: //FILM[ROLES/ROLE/PRENOM = "James" and ROLES/ROLE/NOM = "Stewart"]/TITRE :)

(: 5 :)
(: //FILM[ROLES/ROLE/PRENOM = "James" and ROLES/ROLE/NOM = "Stewart" and ROLES/ROLE/PRENOM = "Kim" and ROLES/ROLE/NOM = "Novak"]/TITRE :)

(: 6 :)
(: //FILM[RESUME]/TITRE :)

(: 7 :)
(: //FILM[not(RESUME)]/TITRE :)

(: 8 :)
(: //FILM[TITRE = "Vertigo"]/MES/@idref :)

(: 9 :)
(: //FILM[TITRE = "Reservoir dogs"]//ROLE[PRENOM="Harvey" and NOM="Keitel"]/INTITULE :)

(: 10 : Le grand bleu :)
(: //FILM[count(//FILM)] :)
(: /descendant::FILM[count(//FILM)] :)

(: 11 :)
(: //FILM[TITRE = "Shining"]/preceding-sibling::*[1]/TITRE :)

(: 12 :)
(: 13 :)
(: //FILM[contains(TITRE, "V")]/TITRE :)

(: 14 :)
(: /descendant::*[count(*) = 3] :)

(: 15 :)
(: //*[contains(name(), "TU")] :)