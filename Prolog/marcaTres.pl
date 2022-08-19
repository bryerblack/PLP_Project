:- module(marcaTres, []).
:- use_module(util).
:- use_module(powerUps).


startGame(Player, Syb, Dim) :- 
    (Dim = 0 -> Dim2 = 5, MultDim = 25; Dim2 = 7, MultDim = 49),
    util:createBoard(MultDim,Board),nl,nl,nl,
    (Player = 0 ->
        powerUps:sortPower(Power1),
        powerUps:sortPower(Power2),
        round_player(Syb,Board,1,Dim2,0,0,Power1,Power2);
        
        powerUps:sortPower(Power1),
        round_machine(Power1)
    ),
    write('Pressione qualquer tecla para continuar...\n\n'),
    get_single_char(_).

teste:-
    util:createBoard(25,Board),
    powerUps:sortPower(Power1),
    powerUps:sortPower(Power2),
    round_player(['X','O'],Board,1,5,0,0,Power1,Power2).





round_player([Syb1,Syb2|[]],Board,Turn,Dim,Score1,Score2,Power1,Power2):-
    format('~w: Jogador 1   ~w: Jogador 2\n', [Syb1, Syb2]),
    format('~w: ~w           ~w: ~w\n\n', [Syb1,Score1,Syb2,Score2]),
    util:printBoard(Board,Dim), nl,
    (Turn = 1 -> 
        P = 'Jogador 1', Syb = Syb1, Power = Power1; 
        P = 'Jogador 2', Syb = Syb2, Power = Power2),
    printPower(Turn,Power1,Power2),
    format('Turno: ~w\n',P),
    (readPos(Dim,Dim,Index)->
        (Index = 0 ->
            % chamou o poder
                
            (Power = 0 ->
                write('\n\nInválido! Poder já usado\n'),
                round_player([Syb1,Syb2],Board,Turn,Dim,Score1,Score2,Power1,Power2);
                
                MultiDim is Dim*Dim,
                powerUps:callPower(Board,MultiDim,Dim,Syb,Power,NewBoard),
                changePower(Turn,Power1,Power2,NewPower1,NewPower2)

            )
            
            ;

            % senao, checar se espaço está livre
            (util:checkFree(Board,Index) -> 
                util:printMsg,
                util:setCell(Board,Index,Syb,NewBoard),
                NewPower1 = Power1 , NewPower2 = Power2;
                
                write('\n\nInválido! tente novamente\n'),
                round_player([Syb1,Syb2],Board,Turn,Dim,Score1,Score2,Power1,Power2)        
            )

        ),
        % com chamada de poder ou não, vai retornar um novo tabuleiro
        changeTurn(Turn,NewTurn),
        (util:checkBoardFree(NewBoard) ->
            %somar pontos, continuar jogo
            updateScore(Score1,Score2,Turn,Index,Board,Dim,Syb,NewScore1,NewScore2),
            round_player([Syb1,Syb2],NewBoard,NewTurn,Dim,NewScore1,NewScore2,NewPower1,NewPower2);
            %comparar pontos e finalizar 
            util:printBoard(NewBoard,Dim),
            winner(Score1,Score2,Syb1,Syb2)
        )
        ;
        write('\n\nInválido! tente novamente\n'),
        round_player([Syb1,Syb2],Board,Turn,Dim,Score1,Score2,Power1,Power2)
    ).





round_machine:- write('nada'), nl.


changeTurn(1,2).
changeTurn(2,1).


readPos(Col,Line,Index):-
    util:readXY([X,Y]),
    (X = 0, Y = 0 ->
        Index = 0
        ;
        util:checkInRange(Col,Line,X,Y),
        util:transformePos(X,Y,Col,Index)
    ).


printPower(1,Power1,_):- print_p(Power1).
printPower(2,_,Power2):- print_p(Power2).

print_p(0):- write('Power: Esgotado\n').
print_p(1):- write('Power: Remove Jogada\n').
print_p(2):- write('Power: Lupin\n').
print_p(3):- write('Power: Blip\n').
print_p(4):- write('Power: Jogar Sorte\n').
print_p(5):- write('Power: Bomba\n').

% colocar 0 no poder que foi usado
changePower(1,_,Power2,0,Power2).
changePower(2,Power1,_,Power1,0).


% verificar vencedor ou empate
winner(Score,Score,_,_):-
    write('\n\nEmpate!!\n\n').
winner(Score1,Score2,Syb1,Syb2):-
    (Score1 > Score2 -> 
        format('\n\nVencedor! Jogador 1 ~w venceu com ~w\n\n',[Syb1,Score1]);
        format('\n\nVencedor! Jogador 2 ~w venceu com ~w\n\n',[Syb2,Score2])
    ).


updateScore(Score1,Score2,1,Index,Board,Dim,Syb,NewScore,Score2):-
    sumScore(Index,Board,Dim,Syb,R),
    NewScore is Score1+R.
updateScore(Score1,Score2,2,Index,Board,Dim,Syb,Score1,NewScore):-
    sumScore(Index,Board,Dim,Syb,R),
    NewScore is Score2+R.


sumScore(Index,Board,Dim,Syb,R):-
    score_cellAA(Index,Board,Dim,Syb,R1),
    score_cellBB(Index,Board,Dim,Syb,R2),
    score_cellCC(Index,Board,Dim,Syb,R3),
    score_cellDD(Index,Board,Dim,Syb,R4),
    score_cellEE(Index,Board,Dim,Syb,R5),
    score_cellFF(Index,Board,Dim,Syb,R6),
    score_cellGG(Index,Board,Dim,Syb,R7),
    score_cellHH(Index,Board,Dim,Syb,R8),
    score_cellAH(Index,Board,Dim,Syb,R9),
    score_cellBG(Index,Board,Dim,Syb,R10),
    score_cellCF(Index,Board,Dim,Syb,R11),
    score_cellDE(Index,Board,Dim,Syb,R12),
    R is R1+R2+R3+R4+R5+R6+R7+R8+R9+R10+R11+R12.


cellA(X,D,I):- I is X-D-1.
cellB(X,D,I):- I is X-D.
cellC(X,D,I):- I is X-D+1.
cellD(X,_,I):- I is X-1.
cellE(X,_,I):- I is X+1.
cellF(X,D,I):- I is X+D-1.
cellG(X,D,I):- I is X+D.
cellH(X,D,I):- I is X+D+1.


score_cellAA(Index,Board,Dim,Syb,R):-
    ((cellA(Index,Dim,X), nth1(X,Board,Syb),
        cellA(X,Dim,X2), nth1(X2,Board,Syb),
        Index2 is Index+Dim-1, Index3 is X+Dim-1,
        verifyLimit(Index2,Dim), verifyLimit(Index3,Dim)
        ) ->
        R=1;R=0
    ).
score_cellBB(Index,Board,Dim,Syb,R):-
    ((cellB(Index,Dim,X), nth1(X,Board,Syb),
        cellB(X,Dim,X2), nth1(X2,Board,Syb)) ->
        R=1;R=0
    ).
score_cellCC(Index,Board,Dim,Syb,R):-
    ((cellC(Index,Dim,X), nth1(X,Board,Syb),
        cellC(X,Dim,X2), nth1(X2,Board,Syb),
        verifyLimit(Index,Dim), verifyLimit(X,Dim)) ->
        R=1;R=0
    ).
score_cellDD(Index,Board,Dim,Syb,R):-
    ((cellD(Index,Dim,X), nth1(X,Board,Syb),
        cellD(X,Dim,X2), nth1(X2,Board,Syb),
        Index2 is Index+Dim-1, Index3 is X+Dim-1,
        verifyLimit(Index2,Dim), verifyLimit(Index3,Dim)) ->
        R=1;R=0
    ).
score_cellEE(Index,Board,Dim,Syb,R):-
    ((cellE(Index,Dim,X), nth1(X,Board,Syb),
        cellE(X,Dim,X2), nth1(X2,Board,Syb),
        verifyLimit(Index,Dim),verifyLimit(X,Dim)) ->
        R=1;R=0
    ).
score_cellFF(Index,Board,Dim,Syb,R):-
    ((cellF(Index,Dim,X), nth1(X,Board,Syb),
        cellF(X,Dim,X2), nth1(X2,Board,Syb),
        Index2 is Index+Dim-1, Index3 is X+Dim-1,
        verifyLimit(Index2,Dim), verifyLimit(Index3,Dim)) ->
        R=1;R=0
    ).
score_cellGG(Index,Board,Dim,Syb,R):-
    ((cellG(Index,Dim,X), nth1(X,Board,Syb),
        cellG(X,Dim,X2), nth1(X2,Board,Syb)) ->
        R=1;R=0
    ).
score_cellHH(Index,Board,Dim,Syb,R):-
    ((cellH(Index,Dim,X), nth1(X,Board,Syb),
        cellH(X,Dim,X2), nth1(X2,Board,Syb),
        verifyLimit(Index,Dim),verifyLimit(X,Dim)) ->
        R=1;R=0
    ).
score_cellAH(Index,Board,Dim,Syb,R):-
    ((cellA(Index,Dim,X), nth1(X,Board,Syb),
        cellH(Index,Dim,X2), nth1(X2,Board,Syb),
        verifyLimit(X,Dim)) ->
        R=1;R=0
    ).
score_cellBG(Index,Board,Dim,Syb,R):-
    ((cellB(Index,Dim,X), nth1(X,Board,Syb),
        cellG(Index,Dim,X2), nth1(X2,Board,Syb)) ->
        R=1;R=0
    ).
score_cellCF(Index,Board,Dim,Syb,R):-
    ((cellC(Index,Dim,X), nth1(X,Board,Syb),
        cellF(Index,Dim,X2), nth1(X2,Board,Syb),
        verifyLimit(Index,Dim), Index2 is Index+Dim-1,
        verifyLimit(Index2,Dim)) ->
        R=1;R=0
    ).
score_cellDE(Index,Board,Dim,Syb,R):-
    ((cellD(Index,Dim,X), nth1(X,Board,Syb),
        cellE(Index,Dim,X2), nth1(X2,Board,Syb),
        verifyLimit(Index,Dim), Index2 is Index+Dim-1,
        verifyLimit(Index2,Dim)) ->
        R=1;R=0
    ).

verifyLimit(X,Dim):- X mod Dim =\= 0.


