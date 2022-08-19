:- module(powerUps, []).
:- use_module(util).

% Tentar fazer repetição de rodada antes de apagar o espaço no lugar de rodada inválida
removeJogada(Board, _, Indx, _):- util:checkFree(Board, Indx), write('posicao inválida!').
removeJogada(Board, Syb, Indx, _):- nth1(Indx, Board, Syb), write('posicao inválida!').
removeJogada(Board, _, Indx, Col):- util:setCell(Board, Indx, '_', NewBoard),
                                    util:printBoard(NewBoard, Col).

lupin(Board, _, Indx, _):- util:checkFree(Board, Indx), write('posicao inválida!').
lupin(Board, Syb, Indx, _):- nth1(Indx, Board, Syb), write('posicao inválida!').
lupin(Board, Syb, Indx, Col):- util:setCell(Board, Indx, Syb, NewBoard),
                               util:printBoard(NewBoard, Col).

blip(Dim, Col):- util:createBoard(Dim, NewBoard),
            util:printBoard(NewBoard, Col).

jogarSorte(Board, _, Col, Dim):- random(0, Dim, 0), write('Azar! Nada ocorreu'),nl, util:printBoard(Board,Col), !.
jogarSorte(Board, Syb, Col, Dim):- random(0,Dim, R), util:setCell(Board, R, Syb, NewBoard),
                                   util:printBoard(NewBoard, Col), !.

bomba(Board, Syb, Col, Dim, X, Y):- util:transformePos(X,Y,Col,Indx), util:setCell(Board,Indx,Syb,NewBoard),
                                    util:printBoard(NewBoard,Col),nl,nl, write('BOMBA! pressione qualquer tecla para detonar!'),
                                    get_single_char(_),nl,nl,
                                    util:setCell(NewBoard,Indx,'_',NB),
                                    popDiags(NB,X,Y,Col,Dim,Syb,4,NewBoardFinal),
                                    util:printBoard(NewBoardFinal, Col).

popDiags(B,_,_,_,_,_,0,B).
popDiags(Board,X,Y,Col,Dim,Syb,Cnt,NewBoard):-
                                    ((Cnt == 4 -> getSupRightDiag(X,Y,Col,Indx));
                                    (Cnt == 3 -> getSupLeftDiag(X,Y,Col,Indx));
                                    (Cnt == 2 -> getInfRightDiag(X,Y,Col,Indx));
                                    (Cnt == 1 -> getInfLeftDiag(X,Y,Col,Indx))),
                                    Cnt1 is Cnt-1,
                                    ((Indx =< Dim, Indx >= 1) -> util:setCell(Board,Indx,Syb,NBoard),
                                    popDiags(NBoard,X,Y,Col,Dim,Syb,Cnt1,NewBoard)); Cnt1 is Cnt-1,
                                    popDiags(Board,X,Y,Col,Dim,Syb,Cnt1,NewBoard).

getSupRightDiag(X,Y,Col,Indx):- ((X+1) =< Col, (Y-1) >= 1) -> util:transformePos(X+1,Y-1,Col,Indx).
getSupRightDiag(_,_,_,0).
getSupLeftDiag(X,Y,Col,Indx):- ((X-1) >= 1, (Y-1) >= 1) -> util:transformePos(X-1,Y-1,Col,Indx).
getSupLeftDiag(_,_,_,0).
getInfRightDiag(X,Y,Col,Indx):- ((X+1) =< Col, (Y+1) =< Col) -> util:transformePos(X+1,Y+1,Col,Indx).
getInfRightDiag(_,_,_,0).
getInfLeftDiag(X,Y,Col,Indx):- ((X-1) >= 1, (Y+1) =< Col) -> util:transformePos(X-1,Y+1,Col,Indx).
getInfLeftDiag(_,_,_,0).

verifyLimit(X,Dim):- X mod Dim =\= 0.

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
        write(NewBoard).