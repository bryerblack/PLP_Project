:- module(classico, []).
:- use_module(util).

startGame(Player, Syb) :- 
    (Player = 0 -> P1 = 'Jogador'; P1 = 'Maquina'),
    format('\n\njogo contra ~w\no simbolo ~w\n\n', [P1, Syb]),
    write('NÃO TEM NADA FEITO\n\n'),
    write('Pressione qualquer tecla para continuar...\n\n'),
    get_single_char(_).