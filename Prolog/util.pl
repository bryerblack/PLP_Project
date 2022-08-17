:- module(util, []).

createBoard(0,[]).
createBoard(X,['_'|T]):- Z is X-1, createBoard(Z,T).

% imprimir as colunas para o tabuleiro
writeCol(1):-
      write('   1 ').
writeCol(X):-
      X1 is X-1,
      writeCol(X1),
      format('~w ',X).

% imprimir tabuleiro
renderBoard([],_,_,_).
renderBoard(Board,Col,_,0):-
      writeCol(Col),nl,
      renderBoard(Board,Col,1,1).
renderBoard([H|T],Col,Line,1):-
    writef('%w |%w',[Line,H]),
    NLine is Line+1,
    renderBoard(T,Col,NLine,2). 
renderBoard([H|T],Col,Line,Col):-  
    writef('|%w|',[H]),nl,
    renderBoard(T,Col,Line,1).
renderBoard([H|T],Col,Line,Cnt):-
    writef('|%w',[H]),
    NCnt is Cnt + 1, 
    renderBoard(T,Col,Line,NCnt). 

% iniciar a clausula de imprimir o tabuleiro
printBoard(Board,Col):-
      renderBoard(Board,Col,0,0).


% verificar se espaço está livre
checkFree(Board,Indx):- nth1(Indx,Board,'_').

% verificar se tabuleior está cheio
checkBoardFree(Board):- member('_', Board).

setCell([_|T],1,Syb,[Syb|T]).
setCell([H|T],Indx,Syb,[H|R]):- Indx > 1, Indx1 is Indx - 1, setCell(T,Indx1,Syb,R), !.

% troca posição x y por indice de lista
transformePos(X,1,_,X,0).
transformePos(X,Y,Col,Col,R):- 
    Y1 is Y-1, 
    transformePos(X,Y1,Col,1,R1), 
    R is R1+1.
transformePos(X,Y,Col,Cont,R):- 
    Cont1 is Cont+1, 
    transformePos(X,Y,Col,Cont1,R1), 
    R is R1+1.


% para transformar atom XO em [X,O] 
atomList(Syb, ListSyb) :-
      name(Syb, Xs),
      maplist(number_to_character, Xs, ListSyb).
      
number_to_character(Number, ListSyb) :-
      name(ListSyb, [Number]).

% Ler as posições X Y
readXY(R):-
      write('Digitar dois números x y:\n'),
      read_line_to_codes(user_input, X1),
      string_to_atom(X1, X),
      atomList(X,R1),
      include(number, R1, R).

checkInRange(Col,Line,X,Y):- (X =< Col, X > 0), (Y =< Line, Y > 0).
      
readPos(Col,Line,Index):-
      readXY([X,Y]),
      checkInRange(Col,Line,X,Y),
      transformePos(X,Y,Col,0,Index).





