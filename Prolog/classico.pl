:- module(classico, []).
:- use_module(util).

/*
startGame(Player, Syb) :- 
    (Player = 0 -> P1 = 'Jogador'; P1 = 'Maquina'),
    format('\n\njogo contra ~w\no simbolo ~w\n\n', [P1, Syb]),
    write('NÃO TEM NADA FEITO\n\n'),
    write('Pressione qualquer tecla para continuar...\n\n'),
    get_single_char(_).
*/

startGame(Player, Syb) :- 
    util:createBoard(9,Board), nl,nl,nl,
    (Player = 0 -> 
        util:atomList(Syb, ListSyb),
        round_player(ListSyb, Board,1);
        round_machine),

    write('Pressione qualquer tecla para continuar...\n\n'),
    get_single_char(_).
    

round_player([Syb1|[Syb2|[]]], Board,Turn):-
    format('~w: Jogador 1  ~w: Jogador 2\n\n', [Syb1, Syb2]),
    util:printBoard(Board,3), nl,
    (Turn = 1 -> P = 'Jogador 1'; P = 'Jogador 2'),
    format('Turno: ~w\n',P),
    util:readXY(L),
    % falta:
        %tratamento das posições recebidas:
            %transformar L em X e Y
            %verificar se X e Y estão nos limites de coluna e linha, senao chama readXY
            %verificar se posição está livre (checkFree), senao chama readXY
            % ---> comecei em util:readPos
        %colocar peça do jogador no tabuleiro -> setCell
        %trocar turn
    write(L),nl,nl. 







round_machine:- write('nada'), nl.