-- Active: 1664356873766@@db-oracle.ufr-info-p6.jussieu.fr@1521@E21216136@E21216136
-- compléter l'entête 
-- ==================

-- NOM    : VIN
-- Prénom : Charles

-- ================================================
-- R1.	Quel est le nom et le prix au kilo des matières ?
-- prompt 'R1:'
SELECT nom, prix_au_kilo FROM Les_Matieres;


-- R2.	Quel est le nom des matières dont le prix au kilo est inférieur à 5 EUR ?
-- prompt 'R2:'
SELECT nom FROM Les_Matieres WHERE prix_au_kilo < 5;


-- R3.	Quelles sont les pièces de base en bois ?
-- prompt 'R3:'
SELECT p.nom
    FROM Les_Pieces_Bases p
    WHERE p.est_en = (SELECT ref(m) from Les_Matieres m WHERE m.nom = 'bois');

-- R4.	Quel est le nom des matières dont le libellé contient "fer" ?
-- prompt 'R4:'
SELECT * FROM Les_Matieres m WHERE m.nom LIKE '%fer%';


-- R5.	Donner le nom des pièces de base formant la pièce nommée 'billard'
-- prompt 'R5:'
SELECT deref(cp.quoi).nom 
    FROM Les_Pieces_Composites c, TABLE(c.contient_pieces) cp 
    WHERE c.nom='billard' ;


-- R6.	Donner le nom de chaque matière avec son nombre de pièces de bases.
-- prompt 'R6:'
SELECT deref(p.est_en).nom ,COUNT(p.est_en)
    FROM Les_Pieces_Bases p
    GROUP BY p.est_en
;

-- R7.	Quelles sont les matières pour lesquelles il existe au moins 3 pièces de base ?
-- prompt 'R7:'
SELECT deref(p.est_en).nom, COUNT(p.est_en)
    FROM Les_Pieces_Bases p
    GROUP BY p.est_en
    HAVING COUNT(p.est_en) >=3
;

