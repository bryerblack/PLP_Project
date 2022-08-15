:- module(classico, [play/3]).

play(Player, Syb1, Syb2) :- 
    (Player = 0 -> P1 = 'Jogador'; P1 = 'Maquina'),
    format('\n\njogo contra ~w\no simbolo ~w ~w\n\n', [P1, Syb1, Syb2]),
    write('NÃO TEM NADA FEITO\n\n'),
    write('Pressione qualquer tecla para continuar...\n\n'),
    get_single_char(_).