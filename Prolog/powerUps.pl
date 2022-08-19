:- module(powerUps, []).
:- use_module(util).

% Tentar fazer repetição de rodada antes de apagar o espaço no lugar de rodada inválida
removeJogada(Board, _, Indx, Col, NewBoard):- 
    util:setCell(Board, Indx, '_', NewBoard).

lupin(Board, Syb, Indx, Col, NewBoard):- 
    util:setCell(Board, Indx, Syb, NewBoard).


blip(Dim, Col,NewBoard):- 
    util:createBoard(Dim, NewBoard).


% ajeitar?
jogarSorte(Board, Syb, Col, Dim, NewBoard):- 
    random(0,Dim, R),
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

sortPower(Power):- random(1,5,Power).

callPower(Board,_,_,_,0,Board).

callPower(Board,Dim,Col,Syb,1,NewBoard):-
    write('Para ser apagada\n'),
    util:readPos(Col,Col,Indx),

    (util:checkFree(Board,Index),  nth1(Indx, Board, Syb) -> 
        write('posicao inválida!'),
        callPower(Board,Dim,Col,Syb,1,NewBoard)
        ; 
        removeJogada(Board,Syb,Indx,Col,NewBoard),
        write('Ops! Posição Apagada hihi'),nl
    ).
    
callPower(Board,Dim,Col,Syb,2,NewBoard):-
    write('Para roubar peça\n'),
    util:readPos(Col,Col,Indx),

    (util:checkFree(Board,Index),  nth1(Indx, Board, Syb) -> 
        write('posicao inválida!'),
        callPower(Board,Dim,Col,Syb,1,NewBoard)
        ; 
        lupin(Board,Syb,Indx,Col,NewBoard),
        write('Essa posição será uma ótima adição à minha coleção!'),nl
    ).
    
callPower(Board,Dim,Col,Syb,3,NewBoard):-
    blip(Dim,Col,NewBoard),
    write('Eu sou inevitável'),nl.

callPower(Board,Dim,Col,Syb,4,NewBoard):-
    write('E qual será a posição da vez? ...'),nl,
    jogarSorte(Board,Syb,Col,Dim,NewBoard).
    
callPower(Board,Dim,Col,Syb,5,NewBoard):-
    util:readXY(Pos),
    util:checkInRange(Pos),
    bomba(Board,Syb,Col,Dim,Pos,NewBoard).

/*
test:- util:createBoard(9,Board),
    util:setCell(Board, 5, 'X', Board1),
    util:printBoard(Board1, 3),nl,
    removeJogada(Board1, 'O', 5, 3),nl,nl,nl,
    util:setCell(Board, 5, 'X', Board2),
    util:printBoard(Board2, 3),nl,
    lupin(Board2, 'O', 5, 3),nl,nl,nl,
    util:setCell(Board,5,'X',Board3),
    util:setCell(Board3,6,'O',Board4),
    util:printBoard(Board4, 3),nl,
    blip(9,3),nl,nl,nl,
    jogarSorte(Board, 'A', 3, 9),nl,nl,nl,
    jogarSorte(Board, 'A', 3, 9),nl,nl,nl,
    bomba(Board,'B',3,9,2,2),nl,nl,nl,
    bomba(Board,'H',3,9,1,2),nl,nl,nl,
    bomba(Board,'H',3,9,3,3).

testPop:- util:createBoard(9,Board),
        popDiags(Board,3,3,3,9,'X',4,NewBoard),
        write(NewBoard). */