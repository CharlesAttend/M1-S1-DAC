-- Active: 1664356873766@@db-oracle.ufr-info-p6.jussieu.fr@1521@E21216136@E21216136
-- compléter l'entête 
-- ==================

-- NOM    : VIN
-- Prénom : Charles

-- ================================================

-- Lister les types
SELECT object_name, object_type, STATUS
	FROM user_objects
	ORDER BY object_type, object_name, STATUS;
/
-- Supprimer un type
DROP TYPE forme force;
/


--------------------------
--------Question 2--------
--------------------------

CREATE TYPE Piece AS OBJECT (
	nom varchar(20)
) not final;
/
CREATE TYPE Matiere AS OBJECT (
	nom varchar(20),
	prix number,
	masse number
);
/

CREATE TYPE Forme AS OBJECT (
	nom varchar(20)
);
/

CREATE TYPE PBase UNDER Piece (
	formeDe Forme,
	composeDe ref Matiere
);
/

CREATE TYPE QuantitePiece AS OBJECT(
	quantite number,
	composeDe Piece
)
/

CREATE TYPE ensQuantitePiece AS TABLE OF QuantitePiece;
/

CREATE TYPE PComposite UNDER Piece (
	composeDe ensQuantitePiece
);
/



show errors







-- liste de tous les types créés
@liste

