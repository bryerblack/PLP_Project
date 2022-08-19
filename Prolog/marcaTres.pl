:- module(marcaTres, []).
:- use_module(util).


startGame(Player, Syb, Dim) :- 
    (Dim = 0 -> Dim2 = 5, MultDim = 25; Dim2 = 7, MultDim = 49),
    util:createBoard(MultDim,Board),nl,nl,nl,
    (Player = 0 ->
        round_player(Syb,Board,1,Dim2,0,0);
        round_machine(Syb,Board,1,Dim2,0,0)
    ),
    write('Pressione qualquer tecla para continuar...\n\n'),
    get_single_char(_).



round_player([Syb1,Syb2|[]],Board,Turn,Dim,Score1,Score2):-
    format('~w: Jogador 1   ~w: Jogador 2\n', [Syb1, Syb2]),
    format('~w: ~w           ~w: ~w\n\n', [Syb1,Score1,Syb2,Score2]),
    util:printBoard(Board,Dim), nl,
    (Turn = 1 -> P = 'Jogador 1', Syb = Syb1; P = 'Jogador 2', Syb = Syb2),
    format('Turno: ~w\n',P),
    (util:readPos(Dim,Dim,Index), util:checkFree(Board,Index) ->
        util:printMsg,
        util:setCell(Board,Index,Syb,NewBoard),
        changeTurn(Turn,NewTurn),
        (util:checkBoardFree(NewBoard) ->
            %somar pontos, continuar jogo
            updateScore(Score1,Score2,Turn,Index,Board,Dim,Syb,NewScore1,NewScore2),
            round_player([Syb1,Syb2],NewBoard,NewTurn,Dim,NewScore1,NewScore2);
            %comparar pontos e finalizar 
            util:printBoard(NewBoard,Dim),
            winner(Score1,Score2,Syb1,Syb2)
        );
        write('\n\nInválido! tente novamente\n'),
        round_player([Syb1,Syb2],Board,Turn,Dim,Score1,Score2)
    ).





round_machine([Syb1,Syb2|[]],Board,Turn,Dim,Score1,Score2):-
    format('~w: Jogador 1   ~w: Máquina\n\n', [Syb1, Syb2]),
    format('~w: ~w           ~w: ~w\n\n', [Syb1,Score1,Syb2,Score2]),
    util:printBoard(Board,Dim),nl,
    (Turn = 1 -> P = 'Jogador 1', Syb = Syb1; P = 'Máquina', Syb = Syb2),
    format('Turno: ~w\n',P),
    (Turn = 1 -> (util:readPos(Dim,Dim,Index), util:checkFree(Board,Index)->
        util:printMsg,
        util:setCell(Board,Index,Syb,NewBoard),
        changeTurn(Turn,NewTurn),
        (util:checkBoardFree(NewBoard) ->
            %somar pontos, continuar jogo
            updateScore(Score1,Score2,Turn,Index,Board,Dim,Syb,NewScore1,NewScore2),
            round_machine([Syb1,Syb2],NewBoard,NewTurn,Dim,NewScore1,NewScore2);
            %comparar pontos e finalizar 
            util:printBoard(NewBoard,Dim),
            winner(Score1,Score2,Syb1,Syb2)
        );
        (write('\n\nInválido! tente novamente\n'),
        round_machine([Syb1,Syb2],Board,Turn,Dim,Score1,Score2)));
        (length(Board, Length),
         random_between(1,Length,R), util:checkFree(Board,R) ->
            (util:setCell(Board,R,Syb,NewBoard),
            changeTurn(Turn,NewTurn),
            (util:checkBoardFree(NewBoard) ->
                %somar pontos, continuar jogo
                updateScore(Score1,Score2,Turn,R,Board,Dim,Syb,NewScore1,NewScore2),
                round_machine([Syb1,Syb2],NewBoard,NewTurn,Dim,NewScore1,NewScore2);
                %comparar pontos e finalizar 
                util:printBoard(NewBoard,Dim),
                winner(Score1,Score2,Syb1,Syb2)
            );
            (round_machine([Syb1,Syb2],Board,Turn,Dim,Score1,Score2))
            ))
        ).


changeTurn(1,2).
changeTurn(2,1).

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