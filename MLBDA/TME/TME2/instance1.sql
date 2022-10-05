-- Active: 1664356873766@@db-oracle.ufr-info-p6.jussieu.fr@1521@E21216136@E21216136
-- compléter l'entête 
-- ==================

-- NOM    : VIN
-- Prénom : Charles

-- ================================================

-- stockage des données : définition des relations
-- ====================
create table Les_Matieres of T_Matiere;

create table Les_Pieces_Bases of T_Piece_Base
    nested table entre_dans store as t1;

create table Les_Pieces_Composites of T_Piece_composite
    nested table entre_dans store as t2
    nested table contient_pieces store as t3;



-- instanciation des objets
-- ========================
-- Question 2
INSERT INTO Les_Matieres VALUES (T_Matiere('bois', 10, 2));
INSERT INTO Les_Matieres VALUES (T_Matiere('fer', 5, 3));
INSERT INTO Les_Matieres VALUES (T_Matiere('ferrite', 6, 10));

-- Question 3
-- On skip les procedure pour l'instant, priorité au requete
INSERT INTO Les_Pieces_Bases VALUES (
    T_Cylindre('canne', null, (SELECT ref(m) from Les_Matieres m WHERE m.nom = 'bois'), 2, 30)
);
INSERT INTO Les_Pieces_Bases VALUES (
    T_Sphere('pied', null, (SELECT ref(m) from Les_Matieres m WHERE m.nom = 'bois'), 30)
);
INSERT INTO Les_Pieces_Bases VALUES (
    T_Paral('plateau', null, (SELECT ref(m) from Les_Matieres m WHERE m.nom = 'bois'), 1, 100, 80)
);
INSERT INTO Les_Pieces_Bases VALUES (
    T_Cylindre('clou', null, (SELECT ref(m) from Les_Matieres m WHERE m.nom = 'fer'), 1, 20)
);
INSERT INTO Les_Pieces_Bases VALUES (
    T_Sphere('boule', null, (SELECT ref(m) from Les_Matieres m WHERE m.nom = 'fer'), 30)
);
INSERT INTO Les_Pieces_Bases VALUES (
    T_Cylindre('aimant', null, (SELECT ref(m) from Les_Matieres m WHERE m.nom = 'ferrite'), 2, 5)
);

-- Question 5
INSERT INTO Les_Pieces_Composites VALUES (T_Piece_composite(
    'table', -- nom
    null,  -- entre dans
    100, -- cout
    T_contient_plusieurs(
        T_contient((SELECT ref(p) FROM Les_Pieces_Bases p WHERE p.nom = 'pied'), 4),
        T_contient((SELECT ref(p) FROM Les_Pieces_Bases p WHERE p.nom = 'clous'), 12)
    )
));
INSERT INTO Les_Pieces_Composites VALUES (T_Piece_composite(
    'billard', -- nom
    null,  -- entre dans
    10, -- cout
    T_contient_plusieurs(
        T_contient((SELECT ref(p) FROM Les_Pieces_Bases p WHERE p.nom = 'boule'), 3),
        T_contient((SELECT ref(p) FROM Les_Pieces_Bases p WHERE p.nom = 'canne'), 2)
    )
));

-- J'AI PAS UPDATE LE ENTRE_DANS mais des pièce de base