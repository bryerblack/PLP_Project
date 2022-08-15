createBoard(0,[]).
createBoard(X,['_'|T]):- Z is X-1, createBoard(Z,T).

/*render3x3([Ax,Bx,Cx,Dx,Ex,Fx,Gx,Hx,Ix]):- 
                                      writef('|%w|%w|%w|', [Ax,Bx,Cx]),
                                   nl,writef('|%w|%w|%w|', [Dx,Ex,Fx]),
                                   nl,writef('|%w|%w|%w|', [Gx,Hx,Ix]),nl,nl.

render5x5([A1,A2,A3,A4,A5,B1,B2,B3,B4,B5,C1,C2,C3,C4,C5,D1,D2,D3,D4,D5,E1,E2,E3,E4,E5]):- 
                writef('|%w|%w|%w|%w|%w|', [A1,A2,A3,A4,A5]),
             nl,writef('|%w|%w|%w|%w|%w|', [B1,B2,B3,B4,B5]),
             nl,writef('|%w|%w|%w|%w|%w|', [C1,C2,C3,C4,C5]),
             nl,writef('|%w|%w|%w|%w|%w|', [D1,D2,D3,D4,D5]),
             nl,writef('|%w|%w|%w|%w|%w|', [E1,E2,E3,E4,E5]),nl,nl.

render7x7([A1,A2,A3,A4,A5,A6,A7,B1,B2,B3,B4,B5,B6,B7,C1,C2,C3,C4,C5,C6,C7,D1,D2,D3,D4,D5,D6,D7,E1,E2,E3,E4,E5,E6,E7,F1,F2,F3,F4,F5,F6,F7,G1,G2,G3,G4,G5,G6,G7]):- 
                writef('|%w|%w|%w|%w|%w|%w|%w|', [A1,A2,A3,A4,A5,A6,A7]),
             nl,writef('|%w|%w|%w|%w|%w|%w|%w|', [B1,B2,B3,B4,B5,B6,B7]),
             nl,writef('|%w|%w|%w|%w|%w|%w|%w|', [C1,C2,C3,C4,C5,C6,C7]),
             nl,writef('|%w|%w|%w|%w|%w|%w|%w|', [D1,D2,D3,D4,D5,D6,D7]),
             nl,writef('|%w|%w|%w|%w|%w|%w|%w|', [E1,E2,E3,E4,E5,E6,E7]),
             nl,writef('|%w|%w|%w|%w|%w|%w|%w|', [F1,F2,F3,F4,F5,F6,F7]),
             nl,writef('|%w|%w|%w|%w|%w|%w|%w|', [G1,G2,G3,G4,G5,G6,G7]),nl,nl.*/

renderBoard([],_,0,_).
renderBoard([H|T],Col,Len,Cnt):- Cnt == 0 -> renderBoard([H|T],Col,Len,1).
renderBoard([H|T],Col,Len,Cnt):- Cnt == 1 -> writef('|%w',[H]), NCnt is Cnt + 1, NLen is Len -1, renderBoard(T,Col,NLen,NCnt).
renderBoard([H|T],Col,Len,Cnt):- Col > Cnt, Cnt > 1 -> writef('|%w',[H]), NCnt is Cnt + 1, NLen is Len -1, renderBoard(T,Col,NLen,NCnt).
renderBoard([H|T],Col,Len,Cnt):- Cnt == Col -> writef('|%w|',[H]),nl, NCnt is 0, NLen is Len -1, renderBoard(T,Col,NLen,NCnt). 

checkFree(B,Indx,R):- nth1(Indx,B,'_'), R = true; R = false.

setCell([_|T],1,Syb,[Syb|T]).
setCell([H|T],Indx,Syb,[H|R]):- Indx > 1, Indx1 is Indx - 1, setCell(T,Indx1,Syb,R), !.
setCell(L,_,_,L).


/*Apenas Para Testar*/
test:- createBoard(9,Board), 
    checkFree(Board,3,Rb),
    write(Rb),nl,
    renderBoard(Board,3,9,0),
    nl,
    setCell(Board,3,'X',NewBoard),
    checkFree(NewBoard,3,Nr),
    write(Nr),nl,
    renderBoard(NewBoard,3,9,0),
    setCell(NewBoard,2,'O',NewNewBoard),
    checkFree(NewNewBoard,2,Nrr),
    write(Nrr),nl,
    renderBoard(NewNewBoard,3,9,0).

test2:- createBoard(9,Board),
      renderBoard(Board,3,9,0),nl,
      createBoard(25,Board2),
      renderBoard(Board2,5,25,0),nl,
      createBoard(49,Board3),
      renderBoard(Board3,7,49,0).

test3:- createBoard(21,Board),
      renderBoard(Board,3,21,0).