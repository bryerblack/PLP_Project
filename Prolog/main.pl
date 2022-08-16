:- use_module(classico).
:- use_module(marcaTres).
:- use_module(corridaVelha).

main:- menu(0).

menu(Index):-
    Title = '\n\n---------- JOGO DA VELHA ----------\n',
    OP = ['Jogo Clássico\n', 'Jogo Marca-Três\n', 'Jogo Corrida Velha\n', 'Sair\n'],
    writeMenu(Title,OP,'',Index,R),
    acceptOption(R),
    menu(Index).

read_option(X):-
    get_single_char(Y),
    atom_char(X,Y).


update(Index,'w',Limit,R) :- 
                (Index = 0 ->
                    R is Limit;
                    R is Index - 1).
update(Index,'s',Limit,R) :-
                (Index = Limit ->
                    R is 0;
                    R is Index + 1).
update(_,'a',_).


% uso para menu principal, menu para escolher o adversario, os simbolos e dimensão
writeMenu(Title, OP, Mesg, Index, R):-
    write(Title),
    write('\n w/s - mover cursor\n a - selecionar\n\n\n'),
    write(Mesg),
    writeOp(Index, OP),
    read_option(Select),
    (member(Select,['w','s','a']) -> 
        (Select = 'a' -> R = Index, !;
            length(OP, Len),
            Limit is Len-1,
            update(Index, Select, Limit, NewIndex),
            writeMenu(Title, OP, Mesg, NewIndex, R));
        writeMenu(Title, OP, Mesg, Index, R)).



% colocar seta nas opções do menu
writeOp(Index, List):-
    addElement(' -> ', Index, List, R),
    writeList(R).

addElement(X, 0, [H|T], [X,H|T]).
addElement(X,I,[H|T], [H|T1]) :-
    I1 is I-1,
    addElement(X,I1,T,T1).

writeList([]).
writeList([H|T]) :-
    write(H),
    writeList(T).


% fazer as escolhas antes do jogo, depois ir para jogo
acceptOption(3):- halt.
acceptOption(0):- 
    Title = '\n\n---------- JOGO CLÁSSICO ----------\n',
    OP = ['Jogador\n', 'Máquina\n'],
    OP2 = ['Sim\n','Não\n'],
    Mesg = 'Jogar contra:\n',
    Mesg2 = 'Deseja mudar os simbolos dos jogadores?\n',
    writeMenu(Title,OP,Mesg,0,R_player),
    writeMenu(Title,OP2,Mesg2,0,R_symb),
    (R_symb = 1 -> 
        Syb = 'XO'; 
        readSymbol(Syb)),
    classico:startGame(R_player, Syb), !.
acceptOption(1):-
    Title = '\n\n---------- JOGO MARCA-TRÊS ----------\n',
    OP = ['Jogador\n', 'Máquina\n'],
    OP2 = ['Sim\n','Não\n'],
    OP3 = ['5x5\n', '7x7\n'],
    Mesg = 'Jogar contra:\n',
    Mesg2 = 'Deseja mudar os simbolos dos jogadores?\n',
    Mesg3 = 'Dimensão:\n',
    writeMenu(Title,OP,Mesg,0,R_player),
    writeMenu(Title,OP3,Mesg3,0,R_dim),
    writeMenu(Title,OP2,Mesg2,0,R_symb),
    (R_symb = 1 -> 
        Syb = 'XO'; 
        readSymbol(Syb)),
    marcaTres:startGame(R_player, Syb, R_dim), !.
acceptOption(2):-
    Title = '\n\n---------- JOGO CORRIDA VELHA ----------\n',
    OP = ['Jogador\n', 'Máquina\n'],
    OP2 = ['Sim\n','Não\n'],
    OP3 = ['7x3 - 3 Jogadores\n', '9x4 - 4 Jogadores\n'],
    Mesg = 'Jogar contra:\n',
    Mesg2 = 'Deseja mudar os simbolos dos jogadores?\n',
    Mesg3 = 'Dimensão:\n',
    writeMenu(Title,OP,Mesg,0,R_player),
    writeMenu(Title,OP3,Mesg3,0,R_dim),
    writeMenu(Title,OP2,Mesg2,0,R_symb),
    (R_symb = 1 -> 
        Syb = 'XOA'; 
        readSymbol(Syb)),
    corridaVelha:startGame(R_player, Syb, R_dim), !.



% leitura do simbolo
readSymbol(Syb):- 
    nl,nl,
    write('Digite os símbolos todos juntos:\n'),
    write('Ex.: ab para ter A e B\n'),
    read_line_to_codes(user_input, X2),
    string_to_atom(X2, X1),
    string_upper(X1, Syb).  

    
