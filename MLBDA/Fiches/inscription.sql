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

-- c)
SELECT e.nomE, count(*) 
    FROM LesEtudiant e, table(e.contract) u, table(value(e).contenu) s, table(s.presents) p 
    WHERE value(u).code = "4I801" AND ref(e) = value(p) -- p et e réferencent le même objet étudiant
    GROUP BY e.nomE;
-- Mais ici à cause du ref(e) = value(p) on a pas les étudiant abscent
SELECT e.nomE, (
    SELECT count(*)
    FROM table(value(u).contenu) s, table(s.presents) p
    WHERE ref(e) = value(p) as nbSeances
)
FROM LesEtudiants e, table(e.contrat) u
WHERE value(u).code = '4I801';

-- d) 
SELECT e.nom, value(ref(u)).nomU 
FROM LesEtudiants e, table(e.contrat) u
WHERE ref(e) IN (
    SELECT value(p)
    FROM LesUnites u, table(u.contenu) s, table(s.presents) p
    WHERE u.nomU = 'MLBDA' AND s.numero = 2
);

-- Question 3 : Méthode
-- a)
SELECT e.nomE e.creditTotal()
FROM LesEtudiants e,
WHERE e.creditTotal() > 600;

--b)
SELECT value(e1), value(e2)
FROM LesEtudiants e1, LesEtudiants e2
WHERE ref(e1) != ref(e2) AND e1.nbUCommunes(e2) = 10;

-- c) EnsC1(C1('4I801', 18), C1('4I200', 16))
SELECT c.code 
from LesEtudiants e, table(e.notes()) c
WHERE e.numero="3456" AND c.note < 10;

-- d)
member function notes return EnsC AS
    res EnsC1;
    BEGIN
        SELECT C1(value(u).code, n.note) BULK COLLECT INTO res
        FROM table(self.contrat) u, table(value(u).notesInscrits) n
        WHERE n.etu = ref(self);
    RETURN res;
END;

-- Question 4
-- a)
CREATE TYPE EnsU AS TABLE OF ref Unité; -- Ne pas oublié le ref
member function prerequisTousNiveaux return EnsU
    res EnsU;
    BEGIN
        SELECT p BULK COLLECT INTO res
        FROM table(self.prerequis) p
        UNION
        SELECT r FROM table(self.prerequis()) p, table(value(p).prerequisTousNiv()) r;
    RETURN res;
END;