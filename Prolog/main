main:- menu(0).

menu(Z):-
    repeat, nl,
    write("\n\n---------- JOGO DA VELHA ----------\n\n"), nl,
    writeMenu(Z),
    read_option(O),
    update(Z,O,R),
    menu(R).

read_option(X):-
    get_single_char(Y),
    atom_char(X,Y),
    format("\nkeypressed ==> ~w ~w\n", [X,Y]),
    member(X,['w','s','a']).

update(Z,'w',R) :- 
                (Z = 0 ->
                    R is 3,!;
                R is Z - 1), 
                format("\nUP").
update(Z,'s',R) :-
                (Z = 3 ->
                    R is 0,!;
                R is Z + 1),
                format("\nDOWN").
update(_,'a',_):- format("\nACCEPT").
update(_,X,_) :- 
      atom_char(X,Y),
      format("\nYOU pressed ==> ~w ~w (ONLY ARROWS and e)\n",[X,Y]),
      get_single_char(_).

writeMenu(0):-
    write("\n-> Clássico\nMarca-Três\nCorrida-da-Velha\nSair\n").
writeMenu(1):-
    write("\nClássico\n-> Marca-Três\nCorrida-da-Velha\nSair\n").
writeMenu(2):-
    write("\nClássico\nMarca-Três\n-> Corrida-da-Velha\nSair\n").
writeMenu(3):-
    write("\nClássico\nMarca-Três\nCorrida-da-Velha\n-> Sair\n").
    