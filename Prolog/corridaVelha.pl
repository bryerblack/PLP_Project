:- module(corridaVelha, []).
:- use_module(util).
:- use_module(powerUps).

startGame(Syb, Dim) :-
    (Dim = 0 -> 
        Turn = [1,2,3], MultDim = 21,
        sortPower(Power1),
        sortPower(Power2),
        sortPower(Power3),
        Power = [Power1,Power2,Power3];
 
        Turn = [1,2,3,4], MultDim = 36,
        sortPower(Power1),
        sortPower(Power2),
        sortPower(Power3),
        sortPower(Power4),
        Power = [Power1,Power2,Power3,Power4]
    ),
        
    util:createBoard(MultDim,Board),nl,nl,nl,
    playRound(Syb,Board,Turn,Power).

sortPower(Power):- random(1,5,Power).

teste:-
    util:createBoard(21,Board),nl,nl,nl,

    sortPower(Power1),
    sortPower(Power2),
    sortPower(Power3),
    Power = [Power1,Power2,Power3],

    playRound(['X','O','A'],Board,[1,2,3],Power).


playRound(ListSyb,Board,Turn,Power):-
    length(ListSyb,QtdPlayer),
    round_player(ListSyb,Board,Turn,Board2,Power,Power2,R),
    (R = 0 -> 
        write('\nRodada dos jogadores finalizada.\n'),
        write('Pressione qualquer tecla para atirar laser...\n\n'),
        get_single_char(_),
        round_machine(Board2,QtdPlayer,NewBoard),
        rotateList(Turn, NewTurn),
        playRound(ListSyb,NewBoard,NewTurn,Power2);

        write('Pressione qualquer tecla para continuar...\n\n'),
        get_single_char(_)  
    ).




round_player(ListSyb,NewBoard,[],NewBoard,NewPower,NewPower,0):-
    length(ListSyb,QtdPlayer),
    printPlayer(ListSyb),
    util:printBoard(NewBoard,QtdPlayer),nl.

round_player(ListSyb,Board,[H_Turn|T_Turn],NewBoard,Power,NewPower,R):-
    length(ListSyb,QtdPlayer),
    (QtdPlayer = 3 -> Line = 7, MultDim = 21;Line=9, MultDim=36),
    printPlayer(ListSyb),
    util:printBoard(Board,QtdPlayer), nl,
    turn(H_Turn,P,ListSyb,Syb),
    printPower(H_Turn,Power,T_power),
    write('Digite 0 para usar o Power-Up\n'),
    format('Turno: ~w\n',P),
    (readPos(QtdPlayer,Line,Board,Syb,Index) ->
        (Index = 0 ->
            % chamou poder
            powerUps:callPower(Board,MultDim,QtdPlayer,Line,Syb,T_power,NewBoard2,Index2),
            changePower(H_Turn,Power,NewPower2)
            ;
            % senao, checar se espaço está livre
            Index2 = Index,
            (util:checkFree(Board,Index) ->
                util:setCell(Board,Index,Syb,NewBoard2),
                NewPower2 = Power;

                write('\n\nInválido! tente novamente\n'),
                round_player(ListSyb,Board,[H_Turn|T_Turn],NewBoard,Power,NewPower,R)
            )

        ),
        (Index2 =< QtdPlayer, Index2 =\= 0->
            % se chegar na primeira linha, vence
            nl,nl,nl,
            util:printBoard(NewBoard2,QtdPlayer),
            format('\nVencedor! ~w: ~w venceu\n\n',[P,Syb]),
            R=1;
            % continuar jogo
            util:printMsg,
            round_player(ListSyb,NewBoard2,T_Turn,NewBoard,NewPower2,NewPower,0)
        );
        write('\n\nInválido! tente novamente\n'),
        round_player(ListSyb,Board,[H_Turn|T_Turn],NewBoard,Power,NewPower,R)
    ).

round_machine(Board,Col,NewBoard):-
    Col2 is Col+1,
    random(0,Col2,Col3),
    %Col3 is 0,
    (Col3 = 0 -> 
        write('Laser Pifou! Nenhuma coluna destruida!!\n'),
        NewBoard = Board;
        format('Laser destriu coluna ~w!!\n',Col3),
        deleteCol(Board,Col,1,Col3,NewBoard)
    ).


printPlayer([Syb1,Syb2,Syb3|[]]):-
    format('~w: Jogador 1   ~w: Jogador 2   ~w: Jogador 3\n\n', [Syb1,Syb2,Syb3]).
printPlayer([Syb1,Syb2,Syb3,Syb4|[]]):-
    format('~w: Jogador 1   ~w: Jogador 2   ~w: Jogador 3   ~w: Jogador 4\n\n', [Syb1,Syb2,Syb3,Syb4]).


turn(1,'Jogador 1',[Syb1|_],Syb1).
turn(2,'Jogador 2',[_,Syb2|_],Syb2).
turn(3,'Jogador 3',[_,_,Syb3|_],Syb3).
turn(4,'Jogador 4',[_,_,_,Syb4|_],Syb4).


printPower(1,[Power1|_],Power1):- powerUps:print_p(Power1).
printPower(2,[_,Power2|_],Power2):- powerUps:print_p(Power2).
printPower(3,[_,_,Power3|_],Power3):- powerUps:print_p(Power3).
printPower(4,[_,_,_,Power4|_],Power4):- powerUps:print_p(Power4).



% colocar 0 no poder que foi usado
changePower(1,[_,Power2,Power3|[]],[0,Power2,Power3|[]]).
changePower(1,[_,Power2,Power3,Power4|[]],[0,Power2,Power3,Power4|[]]).

changePower(2,[Power1,_,Power3|[]],[Power1,0,Power3|[]]).
changePower(2,[Power1,_,Power3,Power4|[]],[Power1,0,Power3,Power4|[]]).

changePower(3,[Power1,Power2,_|[]],[Power1,Power2,0|[]]).
changePower(3,[Power1,Power2,_,Power4|[]],[Power1,Power2,0,Power4|[]]).

changePower(4,[Power1,Power2,Power3,_|_],[Power1,Power2,Power3,0]).



readPos(Col,Line,Board,Syb,Index):-
    readX(X),
    ( X = 0 ->
        Index = 0;

        nextLine(Board,Col,Line,Syb,Y),
        util:checkInRange(Col,Line,X,Y),
        util:transformePos(X,Y,Col,Index)
    ).


readX(R):-
    write('Escolha uma coluna:\n'),
    read_line_to_codes(user_input, X2),
    string_to_atom(X2, X1),
    atom_number(X1, R).

nextLine(Board,Col,Line,Syb,NextY):-
    (nth0(Index,Board,Syb)->
        X is (Index mod Col),
        transformeIndexPos(X,Y,Col,Index),
        NextY is Y-1;
        NextY = Line
    ).

transformeIndexPos(X,Y,Col,Index):-
    Y is (Index-X+Col)/Col.


rotateList([H|T],R):- append(T,[H],R).


deleteCol(Board,4,10,_,Board).
deleteCol(Board,3,8,_,Board).
%Index é a coluna que quer deletar, LineCont inicia com 1
deleteCol(Board,Col,LineCont,Index,NewBoard):-
    Index2 is Index+Col,
    util:setCell(Board,Index,'_',NewBoard2),
    LineCont2 is LineCont+1,
    deleteCol(NewBoard2,Col,LineCont2,Index2,NewBoard).