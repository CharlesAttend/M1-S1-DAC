-- compléter l'entête 
-- ==================

-- NOM    : VIN
-- Prénom : Charles

-- ================================================

-- On skip les procedure pour l'instant, priorité au requete

-- TME4 bonjour
-- Avant de commencer les questions une par une, on regarde toutes les questions pour bien réfléchir où on instance les méthodes.
-- Car si on se trombe on doit tout supprimer et tout recommencer

--> En faite de toute manière on doit tout refaire pour prédéclarer les méthodes dans le type : voir fichier "schema_avec_methode.sql"
create type body T_cube as (
    overriding member function Volume return number IS (
        BEGIN
        RETURN cote**3
        END ;
    ) 
) END;

create type body T_Piece_Base as (
    overriding member function masse return number IS (
        res number;
        BEGIN
            SELECT deref(self.est_en).masse_volumique * self.Volume() into res
            FROM dual; -- dual = table bidon pour que la requete soit valide
        RETURN res
        END ;
    ) 
) END;