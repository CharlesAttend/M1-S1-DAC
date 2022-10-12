create type T_Matiere as object (
	nom varchar2(30),
	prix_au_kilo number,
	masse_volumique number
);

create type T_Piece;

create type T_Piece_Composite;

create type T_entre_dans as object (
	quoi      ref T_Piece_Composite,
	quantite  number
);

create type T_entre_dans_plusieurs as table of T_entre_dans;

create type T_contient as object (
	quoi      ref T_Piece,
	quantite  number
);

create type T_contient_plusieurs as table of T_Contient;
create type EnsNom as table of varchar2(30);

create type T_Piece as object (
	nom         varchar2(30),
    entre_dans  T_entre_dans_plusieurs,
    not instantiable member function masse return number, -- On rajoute not instantiable pour dire qu'on définie que la signature
    not instantiable member function prix return number,
    not instantiable member function compose_de return EnsNom,
    not instantiable member function nb_piece_base return number
) not instantiable not final ;

create type T_Piece_base under T_Piece (
	est_en ref   T_Matiere,
    not instantiable member function volume return number,
    overriding member function masse return number,
    overriding member function prix return number,
    overriding member function compose_de return EnsNom,
    overriding member function nb_piece_base return number
) not instantiable not final;

create type T_Cube under T_Piece_base (
	cote        number
    overriding member,
    overriding member function volume return number
);

create type T_Sphere under T_Piece_base (
	rayon        number
);

create type T_Cylindre under T_Piece_base (
	diametre        number,
    hauteur         number,
    overriding member function volume return number
);

create type T_Paral under T_Piece_base (
	hauteur        number,
    largeur        number,
    profondeur     number,
    overriding member function volume return number
);

create type T_Piece_composite under T_Piece (
    cout_assemblage  number,
    contient_pieces  T_contient_plusieurs,
    overriding member function masse return number,
    overriding member function prix return number,
    overriding member function compose_de return EnsNom,
    overriding member function nb_piece_base return number
);