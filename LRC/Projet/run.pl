start :-
    % load_files('part2.pl'),
    % load_files('part3.pl'),
    % load_test_files([]),
    % run_tests,
    
    % Import des Box
    load_files('T-A_Box.pl'),
    load_files('part1.pl'),
    % Vérification de la Tbox
    write('Vérification de la TBox ...'), nl,
    setof((CA, CG), equiv(CA, CG), L), verif_Tbox(L), 
    write('Vérification de la TBox réussi'), nl,
    % Vérification de la Abox
    write('Vérification de la ABox ...'), nl,
    setof((I1, I2), inst(I1, I2), LInst), setof((I1, I2,R), instR(I1, I2, R), LInstR), verif_Abox([LInst | LInstR]),
    write('Vérification de la ABox réussi'), nl,
    
    
    write('Programe terminé !').
start.