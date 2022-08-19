:- module(classico, []).
:- use_module(util).


startGame(Player, Syb) :- 
    util:createBoard(9,Board),nl,nl,nl,
    (Player = 0 -> 
        util:atomList(Syb, ListSyb),
        round_player(ListSyb, Board,1);
        util:atomList(Syb, ListSyb),
        round_machine(ListSyb, Board,1)),

    write('Pressione qualquer tecla para continuar...\n\n'),
    get_single_char(_).



round_player([Symbol1, Symbol2|[]], Board, Turn):-
    format('~w: Jogador 1   ~w: Jogador 2\n\n', [Symbol1, Symbol2]),
    util:printBoard(Board,3), nl,
    (Turn = 1 -> P = 'Jogador 1', Syb = Symbol1; P = 'Jogador 2', Syb = Symbol2),
    format('Turno: ~w\n',P),
    (util:readPos(3,3,Index), util:checkFree(Board,Index)->
        util:printMsg,
        util:setCell(Board,Index,Syb,NewBoard),
        changeTurn(Turn,NewTurn),
        (util:checkBoardFree(NewBoard) ->
            (isWinner(NewBoard,Syb)->
                % vencedor
                util:printBoard(NewBoard,3),
                format('\n\nVencedor! ~w ~w venceu\n\n',[P,Syb]);
                % continuar jogo
                round_player([Symbol1,Symbol2],NewBoard,NewTurn)
            );
            % empate
            util:printBoard(NewBoard,3),
            write('\n\nEmpate!!\n\n')
        );
        write('\n\nInválido! tente novamente\n'),
        round_player([Symbol1,Symbol2],Board,Turn)
    ). 


round_machine([Symbol1, Symbol2|[]], Board, Turn):-
    format('~w: Jogador 1   ~w: Máquina\n\n', [Symbol1, Symbol2]),
    util:printBoard(Board,3), nl,
    (Turn = 1 -> P = 'Jogador 1', Syb = Symbol1; P = 'Máquina', Syb = Symbol2),
    format('Turno: ~w\n',P),
    (Turn == 1, util:readPos(3,3,Index), util:checkFree(Board,Index)->
        util:printMsg,
        util:setCell(Board,Index,Syb,NewBoard),
        changeTurn(Turn,NewTurn),
        (util:checkBoardFree(NewBoard) ->
            (isWinner(NewBoard,Syb)->
                % vencedor
                util:printBoard(NewBoard,3),
                format('\n\nVencedor! ~w ~w venceu\n\n',[P,Syb]);
                % continuar jogo
                round_machine([Symbol1,Symbol2],NewBoard,NewTurn)
            );
            % empate
            util:printBoard(NewBoard,3),
            write('\n\nEmpate!!\n\n')
        );
        write('\n\nInválido! tente novamente\n'),
        round_machine([Symbol1,Symbol2],Board,Turn)
    );
    (Turn == 2, length(Board, Length), random(1, 9, Indx), util:checkFree(Board, Indx) ->
        (setCell(Board, Indx, Symbol2, NewBoard),
        changeTurn(Turn, NewTurn), round_machine([Symbol1,Symbol2],NewBoard,NewTurn));
        (round_machine([Symbol1,Symbol2],Board,Turn))).


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