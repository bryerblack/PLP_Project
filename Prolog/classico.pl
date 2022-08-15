pickSymbol(Symbol1, Symbol2):- write('player 1: '), read(Symbol1), nl,
    write('player 2: '), read(Symbol2), nl.

createBoard(0,[]).
createBoard(X,['_'|T]):- Z is X-1, createBoard(Z,T).

render3x3([Ax,Bx,Cx,Dx,Ex,Fx,Gx,Hx,Ix]):- 
                                      writef('|%w|%w|%w|', [Ax,Bx,Cx]),
                                   nl,writef('|%w|%w|%w|', [Dx,Ex,Fx]),
                                   nl,writef('|%w|%w|%w|', [Gx,Hx,Ix]),nl,nl.

checkFree(B,Indx,R):- nth1(Indx,B,'_'), R = true; R = false.
%checkFree(B,Indx):- nth1(Indx,B,'_').

setCell([_|T],1,Syb,[Syb|T]).
setCell([H|T],Indx,Syb,[H|R]):- Indx > 1, Indx1 is Indx - 1, setCell(T,Indx1,Syb,R), !.
setCell(L,_,_,L).

switchPlayer(Board, Player, Symbol):- Player == 1, NewPlayer is Player + 1, NewSymbol = 'O', playRound(Board, NewPlayer, NewSymbol).
switchPlayer(Board, Player, Symbol):- Player == 2, NewPlayer is Player - 1, NewSymbol = 'X', playRound(Board, NewPlayer, NewSymbol).

isWinner(Board, Symbol):- nth1(1, Board, Symbol), nth1(2, Board, Symbol), nth1(3, Board, Symbol), write('venceu!').
isWinner(Board, Symbol):- nth1(4, Board, Symbol), nth1(5, Board, Symbol), nth1(6, Board, Symbol), write('venceu!').
isWinner(Board, Symbol):- nth1(7, Board, Symbol), nth1(8, Board, Symbol), nth1(9, Board, Symbol), write('venceu!').
isWinner(Board, Symbol):- nth1(1, Board, Symbol), nth1(5, Board, Symbol), nth1(9, Board, Symbol), write('venceu!').
isWinner(Board, Symbol):- nth1(3, Board, Symbol), nth1(5, Board, Symbol), nth1(7, Board, Symbol), write('venceu!').

playRound(Board, Player, Symbol):- write('insira posicao: '), read(Indx),
    checkFree(Board, Indx, R), R == true, setCell(Board, Indx, Symbol, NewBoard),
    nl, render3x3(NewBoard), isWinner(Board, Symbol).

playRound(Board, Player, Symbol):- checkFree(Board, Indx, R), R == false,
    write('posicao invalida, tente novamente.'),
    nl, playRound(Board, Player, Symbol).

main:- createBoard(9, Board),
    nl, render3x3(Board),
    playRound(Board, 1, 'X').
