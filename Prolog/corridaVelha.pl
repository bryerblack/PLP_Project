:- module(corridaVelha, []).
:- use_module(util).

startGame(Player, Syb, Dim) :- 
    (Player = 0 -> P1 = 'Jogador'; P1 = 'Maquina'),
    (Dim = 0 -> D1 = '5x5'; D1 = '7x7'),
    format('\n\njogo contra ~w\nos simbolos: ~w\ndimensão: ~w\n\n', [P1, Syb, D1]),
    write('NÃO TEM NADA FEITO\n\n'),
    write('Pressione qualquer tecla para continuar...\n\n'),
    get_single_char(_).