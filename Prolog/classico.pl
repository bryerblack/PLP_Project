:- module(classico, []).
:- use_module(util).


startGame(Player, Syb) :- 
    util:createBoard(9,Board),nl,nl,nl,
    (Player = 0 -> 
        round_player(Syb, Board,1);
        round_machine(Syb,Board,1)),

    write('Pressione qualquer tecla para continuar...\n\n'),
    get_single_char(_).



round_player([Syb1,Syb2|[]],Board,Turn):-
    format('~w: Jogador 1   ~w: Jogador 2\n\n', [Syb1, Syb2]),
    util:printBoard(Board,3), nl,
    (Turn = 1 -> P = 'Jogador 1', Syb = Syb1; P = 'Jogador 2', Syb = Syb2),
    format('Turno: ~w\n',P),
    (util:readPos(3,3,Index), util:checkFree(Board,Index)->
        util:printMsg,
        util:setCell(Board,Index,Syb,NewBoard),
        changeTurn(Turn,NewTurn),
        (isWinner(NewBoard,Syb) ->
            % vencedor
            util:printBoard(NewBoard,3),
            format('\n\nVencedor! ~w ~w venceu\n\n',[P,Syb]);
            (util:checkBoardFree(NewBoard) -> 
                % continuar jogo
                round_player([Syb1,Syb2],NewBoard,NewTurn);
                % empate
                util:printBoard(NewBoard,3),
                write('\n\nEmpate!!\n\n')
            )
        );
        write('\n\nInválido! tente novamente\n'),
        round_player([Syb1,Syb2],Board,Turn)
    ). 


round_machine([Symbol1, Symbol2|[]], Board, 1):-
    format('~w: Jogador 1   ~w: Máquina\n\n', [Symbol1, Symbol2]),
    util:printBoard(Board,3),nl,
    P = 'Jogador 1', Syb = Symbol1, Turn = 1,
    format('Turno: ~w\n',P),
    (util:readPos(3,3,Index), util:checkFree(Board,Index) ->
        util:printMsg,
        util:setCell(Board,Index,Syb,NewBoard),
        changeTurn(Turn,NewTurn),
        (isWinner(NewBoard,Syb) ->
            % vencedor
            util:printBoard(NewBoard,3),
            format('\n\nVencedor! ~w ~w venceu\n\n',[P,Syb]);
            (util:checkBoardFree(NewBoard) -> 
                % continuar jogo
                round_machine([Symbol1,Symbol2],NewBoard,NewTurn);
                % empate
                util:printBoard(NewBoard,3),
                write('\n\nEmpate!!\n\n')
            )
        );
        write('\n\nInválido! tente novamente\n'),
        round_machine([Symbol1,Symbol2],Board,Turn)
    ).


round_machine([Symbol1, Symbol2|[]], Board, 2):-
    format('~w: Jogador 1   ~w: Máquina\n', [Symbol1, Symbol2]),
    util:printBoard(Board,3),nl,
    P = 'Máquina', Syb = Symbol2,Turn = 2,
    format('Turno: ~w\n\n',P),
    moveMachine(Board,R),
    util:setCell(Board,R,Syb,NewBoard),
    changeTurn(Turn,NewTurn),
    ( isWinner(NewBoard,Syb) ->
        % vencedor
        util:printBoard(NewBoard,3),
        format('\n\nVencedor! ~w ~w venceu\n\n',[P,Syb]);
        (util:checkBoardFree(NewBoard) ->
            % continuar jogo
            util:printBoard(NewBoard,3),
            write('\nPressione qualquer tecla para continuar...\n\n'),
            get_single_char(_),
            round_machine([Symbol1,Symbol2],NewBoard,NewTurn);
            % empate
            util:printBoard(NewBoard,3),
            write('\n\nEmpate!!\n\n')
        )
    ). 



moveMachine(Board,R):-
    random_between(1,9,R2),
    (util:checkFree(Board,R2) ->
        R = R2;
        moveMachine(Board,R)
    ).

changeTurn(1,2).
changeTurn(2,1).


isWinner(Board, Symbol):- 
    (nth1(1, Board, Symbol), nth1(2, Board, Symbol), nth1(3, Board, Symbol));
    (nth1(4, Board, Symbol), nth1(5, Board, Symbol), nth1(6, Board, Symbol));
    (nth1(7, Board, Symbol), nth1(8, Board, Symbol), nth1(9, Board, Symbol));
    (nth1(1, Board, Symbol), nth1(4, Board, Symbol), nth1(7, Board, Symbol));
    (nth1(2, Board, Symbol), nth1(5, Board, Symbol), nth1(8, Board, Symbol));
    (nth1(3, Board, Symbol), nth1(6, Board, Symbol), nth1(9, Board, Symbol));
    (nth1(1, Board, Symbol), nth1(5, Board, Symbol), nth1(9, Board, Symbol));
    (nth1(3, Board, Symbol), nth1(5, Board, Symbol), nth1(7, Board, Symbol)).