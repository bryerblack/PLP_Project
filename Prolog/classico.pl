createBoard(0,[]).
createBoard(X,['_'|T]):- Z is X-1, createBoard(Z,T).

render3x3([Ax,Bx,Cx,Dx,Ex,Fx,Gx,Hx,Ix]):- 
                                      writef('|%w|%w|%w|', [Ax,Bx,Cx]),
                                   nl,writef('|%w|%w|%w|', [Dx,Ex,Fx]),
                                   nl,writef('|%w|%w|%w|', [Gx,Hx,Ix]),nl,nl.

checkFree(B,Indx,R):- nth1(Indx,B,'_'), R = true; R = false.

setCell([_|T],1,Syb,[Syb|T]).
setCell([H|T],Indx,Syb,[H|R]):- Indx > 1, Indx1 is Indx - 1, setCell(T,Indx1,Syb,R), !.
setCell(L,_,_,L).

switchPlayer(Board, Player, Symbol):- isWinner(Board, Symbol), format('o jogador ~w venceu!', [Player]).
switchPlayer(Board, Player, Symbol):- \+ isWinner(Board, Symbol), Player == 1, NewPlayer is Player + 1, NewSymbol = 'O', playRound(Board, NewPlayer, NewSymbol).
switchPlayer(Board, Player, Symbol):- \+ isWinner(Board, Symbol), Player == 2, NewPlayer is Player - 1, NewSymbol = 'X', playRound(Board, NewPlayer, NewSymbol).

isWinner(Board, Symbol):- (nth1(1, Board, Symbol), nth1(2, Board, Symbol), nth1(3, Board, Symbol));
    (nth1(4, Board, Symbol), nth1(5, Board, Symbol), nth1(6, Board, Symbol));
    (nth1(7, Board, Symbol), nth1(8, Board, Symbol), nth1(9, Board, Symbol));
    (nth1(1, Board, Symbol), nth1(4, Board, Symbol), nth1(7, Board, Symbol));
    (nth1(2, Board, Symbol), nth1(5, Board, Symbol), nth1(8, Board, Symbol));
    (nth1(3, Board, Symbol), nth1(6, Board, Symbol), nth1(9, Board, Symbol));
    (nth1(1, Board, Symbol), nth1(5, Board, Symbol), nth1(9, Board, Symbol));
    (nth1(3, Board, Symbol), nth1(5, Board, Symbol), nth1(7, Board, Symbol));
    \+ member('_', Board), write('empate!'), halt.

playRound(Board, Player, Symbol):- write('insira posicao: '), read(Indx),
    checkFree(Board, Indx, R), R == true, setCell(Board, Indx, Symbol, NewBoard),
    nl, render3x3(NewBoard), switchPlayer(NewBoard, Player, Symbol).

playRound(Board, Player, Symbol):- checkFree(Board, Indx, R), R == false,
    write('posicao invalida, tente novamente.'),
    nl, playRound(Board, Player, Symbol).

machineRound(Board, Symbol):- random_between(1, 9, Indx),
    checkFree(Board, Indx, R), R == true, setCell(Board, Indx, Symbol, NewBoard),
    nl, render3x3(NewBoard).

machineRound(Board, Symbol):- random_between(1, 9, Indx),
    checkFree(Board, Indx, R), R == false, machineRound(Board, Symbol).

main:- createBoard(9, Board),
    nl, render3x3(Board),
    playRound(Board, 1, 'X').