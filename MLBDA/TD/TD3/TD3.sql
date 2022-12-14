---------------------------------
-- Voir l'anexe pour le schéma --
---------------------------------

-- Exercice 2 

-- Question 1
insert into LesConsommateurs Values (
    Consomateur(1, 
        'Max', 
        22, 
        null,
        EnsBars((select ref(b) from LesBars b where b.nom = 'Le Select'), 
        EnsBiere((select ref(b) from LesBierres b where b.name = 'stella')) )
));

-- Question 2
INSERT INTO TABLE -- J'avais oublié le table, ON L'UTILISE QUAND ON RÉCUPÈRE UN ENSEMBLE, un type ensembliste
    select c.consomme from LesConsommateurs c where c.nom = "Max"
    VALUES (
        SELECT ref(b) from LesBierres b where b.name = 'Chimay'
    )
-- Bonus : c'est une relation symétrique avec Bière, on doit ajouter dans consommé_par le consomateur

INSERT INTO TABLE (
    SELECT b.consommé_par FROM LesBierres b WHERE b.Marque = "Chimay"
)
VALUES (
    SELECT ref(c) from LesConsommateur c WHERE c.nom = "Max" -- Heuresement qu'il y a qu'un seul Max 
);



-- Excercice 3 
-- Question 1
create table lesUnité of Unité
    nested table contenu store as t1
    nested table noteInscrits store as t2

create table LesEtudiant of Etudiant
    nested table contrat store as t1

-- CORRECTION 
create table lesUnité of Unité
    nested table contenu store as t1 (
        nested table presents store as t3
    )
    nested table noteInscrits store as t4


-- Question 2 
-- a)
insert into lesUnité VALUES (
    Unité('MLBDA', 
        '4I801', 
        6,
        Séances(
            Séance(1, 'SQL', ?), -- On met une instance vide d'étudiant
            Séance(2, 'SQL3', Etudiant()),
            Séance(3, 'XML', Etudiant())
        ),
        EnsC2() -- Pareil ici on met une instance vide 
);

-- b) 
-- c)
INSERT INTO LesEtudiants VALUES Etudiant(
    1,
    2022
    Alice
    28
    Unités(
        SELECT ref(u) from LesUnités WHERE u.code = '4I808',
        SELECT ref(u) from LesUnités WHERE u.code = '4I101',
    )
);

-- d)
INSERT INTO TABLE (
    SELECT s.présents FROM LesUnités u, table(u.contenu) s WHERE u.code = '4I801' AND s.numero = 3
)
VALUES (
    SELECT ref(e) FROM LesEtudiants e WHERE e.nom = 'Alice'
)

-- Question 3
-- a)
SELECT value(e) from LesEtudiants e, table(e.contrat) u WHERE e.age > 25 AND value(u).code = '4I801';

-- b) 
SELECT value(e).nomE FROM LesUnités u, table(u.contenu) s, table(s.present) e where u.nomU = 'MLBDA' AND s.numero = 3;
