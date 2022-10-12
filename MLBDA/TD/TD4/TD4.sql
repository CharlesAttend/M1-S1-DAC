-- Retour exercice 3 
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
SELECT e.nomE, e2.nomE
FROM LesEtudiants e, LesEtudiant e2
WHERE COUNT(e.nbUCommunes(e2)) = 10;
-- Correction
SELECT value(e1), value(e2)
FROM LesEtudiants e1, LesEtudiants e2
WHERE ref(e1) != ref(e2) AND e1.nbUCommunes(e2) = 10

-- c) EnsC1(C1('4I801', 18), C1('4I200', 16))
SELECT c.code 
from LesEtudiants e, e.notes() c
WHERE e.numero="3456" AND c.note < 10;
-- Correction
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