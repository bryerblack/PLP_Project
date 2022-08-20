:- module(powerUps, []).
:- use_module(util).


removeJogada(Board, Indx, NewBoard):- 
    util:setCell(Board, Indx, '_', NewBoard).

lupin(Board, Syb, Indx, NewBoard):- 
    util:setCell(Board, Indx, Syb, NewBoard).


blip(Dim, NewBoard):- 
    util:createBoard(Dim, NewBoard).



jogarSorte(Board, Syb, Dim, NewBoard,R):- 
    Dim2 is Dim + 1,
    random(0,Dim2, R),
    (R == 0 -> 
        write('Azar! Nada ocorreu'),nl, 
        NewBoard = Board
        ;
        util:setCell(Board, R, Syb, NewBoard)
    ),!.


bomba(Board, Syb, Col, Dim, [X,Y], NewBoardFinal):- 
    util:transformePos(X,Y,Col,Indx), 
    util:setCell(Board,Indx,Syb,NewBoard),
    util:printBoard(NewBoard,Col),nl,nl, 
    write('BOMBA! pressione qualquer tecla para detonar!'),
    get_single_char(_),nl,nl,
    util:setCell(NewBoard,Indx,'_',NB),
    popDiags(NB,X,Y,Col,Dim,Syb,4,NewBoardFinal).

popDiags(B,_,_,_,_,_,0,B).
popDiags(Board,X,Y,Col,Dim,Syb,Cnt,NewBoard):-
        ((Cnt == 4 -> getSupRightDiag(X,Y,Col,Indx));
        (Cnt == 3 -> getSupLeftDiag(X,Y,Col,Indx));
        (Cnt == 2 -> getInfRightDiag(X,Y,Col,Indx));
        (Cnt == 1 -> getInfLeftDiag(X,Y,Col,Indx))
        ),
        Cnt1 is Cnt-1,
        ((Indx =< Dim, Indx >= 1) -> 
            util:setCell(Board,Indx,Syb,NBoard),
            popDiags(NBoard,X,Y,Col,Dim,Syb,Cnt1,NewBoard)
        ); 
        Cnt1 is Cnt-1,
        popDiags(Board,X,Y,Col,Dim,Syb,Cnt1,NewBoard).


getSupRightDiag(X,Y,Col,Indx):- 
    ((X+1) =< Col, (Y-1) >= 1) -> util:transformePos(X+1,Y-1,Col,Indx).
getSupRightDiag(_,_,_,0).
getSupLeftDiag(X,Y,Col,Indx):- 
    ((X-1) >= 1, (Y-1) >= 1) -> util:transformePos(X-1,Y-1,Col,Indx).
getSupLeftDiag(_,_,_,0).
getInfRightDiag(X,Y,Col,Indx):- 
    ((X+1) =< Col, (Y+1) =< Col) -> util:transformePos(X+1,Y+1,Col,Indx).
getInfRightDiag(_,_,_,0).
getInfLeftDiag(X,Y,Col,Indx):- 
    ((X-1) >= 1, (Y+1) =< Col) -> util:transformePos(X-1,Y+1,Col,Indx).
getInfLeftDiag(_,_,_,0).





callPower(Board,_,_,_,_,0,Board,0).

callPower(Board,Dim,Col,Lin,Syb,1,NewBoard,Indx2):-
    write('Para ser apagada...\n'),
    util:readPos(Col,Lin,Indx),
    Indx2 = Indx,
    (util:checkFree(Board,Indx),  nth1(Indx, Board, Syb) -> 
        write('posicao inválida!'),
        callPower(Board,Dim,Col,Syb,1,NewBoard)
        ; 
        removeJogada(Board,Indx,NewBoard),
        write('\n\nOps! Posição Apagada hihi'),nl
    ).
    
callPower(Board,Dim,Col,Lin,Syb,2,NewBoard,Indx2):-
    write('Para roubar peça...\n'),
    util:readPos(Col,Lin,Indx),
    Indx2 = Indx,
    (util:checkFree(Board,Indx),  nth1(Indx, Board, Syb) -> 
        write('posicao inválida!'),
        callPower(Board,Dim,Col,Syb,1,NewBoard)
        ; 
        lupin(Board,Syb,Indx,NewBoard),
        write('\n\nEssa posição será uma ótima adição à minha coleção!'),nl
    ).
    
callPower(_,Dim,_,_,_,3,NewBoard,0):-
    blip(Dim,NewBoard),
    write('\n\nEu sou inevitável'),nl.

callPower(Board,Dim,_,_,Syb,4,NewBoard,Indx):-
    write('\nE qual será a posição da vez? ...'),nl,
    jogarSorte(Board,Syb,Dim,NewBoard,Indx).
    
callPower(Board,Dim,Col,_,Syb,5,NewBoard,_):-
    util:readXY(Pos),
    util:checkInRange(Pos),
    bomba(Board,Syb,Col,Dim,Pos,NewBoard).


print_p(0):- write('Power: Esgotado!\n').
print_p(1):- write('Power: Remove Jogada\n').
print_p(2):- write('Power: Lupin\n').
print_p(3):- write('Power: Blip\n').
print_p(4):- write('Power: Jogar Sorte\n').
print_p(5):- write('Power: Bomba\n').

