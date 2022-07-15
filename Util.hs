{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Util (
    CellTransform(..),
    Cell(..),
    printBoard,
    transformeCell,
    assignCell,
    setCell,
    checkPos,
    checkBoardFree,
    verifyIsFree,
    printMsg
)
where

import Data.List (intercalate)
import Data.Type.Coercion (sym)
import System.Random
import Data.Bits ((.&.))


data CellTransform = Success [Cell] (Int, Int) | Fail [Cell]

data Cell = Occupied Char | Empty
                deriving(Eq)

instance Show Cell where
    show (Occupied syb) = [syb]
    show Empty = "_"


-- linha y coluna x

-- Funções para o tabuleiro 
renderBoard:: Int -> Int -> Int -> [Cell] -> String
renderBoard _ _ _ [] = ""
renderBoard i x y board = show i ++ "   " ++ renderRow (take x board) ++ "\n" ++ renderBoard (i+1) x (y-1) (drop x board)


renderRow :: [Cell] -> String
renderRow row = "|" ++ intercalate "|" (fmap show row) ++ "|"

printBoard:: (Int, Int) -> [Cell] -> String
printBoard (x,y) board = "     " ++
                        unwords (fmap show [1 .. x]) ++
                        "\n" ++ renderBoard 1 x y board



setCell::  [Cell] -> Int -> (Int, Int) -> Cell
setCell board _ (xPos, 1) = board !! (xPos-1)
setCell board col (xPos, yPos) = setCell (drop col board) col (xPos, yPos-1)

checkPos:: (Int, Int) -> (Int, Int) -> Bool
checkPos (xPos, yPos) (col, lin) = xPos <= col && xPos > 0 && yPos <= lin && yPos > 0 

checkBoardFree::[Cell] -> Bool
checkBoardFree board = Empty `notElem` board

verifyIsFree::  [Cell] -> Int -> (Int, Int) -> Bool
verifyIsFree board _ (xPos, 1) = board !! (xPos-1) == Empty
verifyIsFree board col (xPos, yPos) = verifyIsFree (drop col board) col (xPos, yPos-1)

-- faz a substituição da peça
transformeCell:: Char -> [Cell] -> Int -> Int -> Int -> [Cell]
transformeCell syb board _ xPos 1 = take (xPos-1) board ++ [Occupied syb] ++ drop xPos board
transformeCell syb board col xPos yPos = take col board ++ transformeCell syb (drop col board) col xPos (yPos-1)

-- faz a verificação do espaço vazio e a substituição da peça
assignCell:: (Int, Int) -> Char -> [Cell] -> (Int, Int) -> CellTransform
assignCell pos@(xPos, yPos) symbol board dim@(col, lin)=
    if checkPos pos dim && verifyIsFree board col (xPos, yPos)
        then Success (transformeCell symbol board col xPos yPos) (xPos, yPos)
        else Fail board


printMsg:: (Int, Int) -> Int -> String
printMsg (xDim,yDim) num =  take (xDim*yDim) (cycle ["OK!", "Boa Jogada!", "Sensacional!"]) !! (num-1)
-- passar num como o primeiro inteiro da tupla do movimentos da máquina, para retorna uma mensagem aleatória.


















{-
lados 1 4 = ([(0,4), (x+1,y), (x,y-1), (x,y+1), (x-1,y-1), (x+1,y+1), (x+1,y-1), (x-1,y+1)],
             [(x-2,y), (x+2,y), (x,y-2), (x,y+2), (x-2,y-2), (x+2,y+2), (x+2,y-2), (x-2,y+2)])
-}

{-
     1 2 3 4 5
1   |_|_|_|_|_|
2   |_|a|b|c|_|
3   |_|d|X|e|_|
4   |_|f|g|h|_|
5   |_|_|_|_|_|

-}


teste1 = [Occupied '0', Empty, Occupied '2', Empty, Occupied '4', Occupied '5', Occupied '6', Occupied '7', Empty]
teste2 = [Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty]
teste3 = [Occupied '0', Occupied '1', Occupied '2', Occupied '3', Occupied '4', Occupied '5', Occupied '6', Occupied '7', Occupied '8']

teste = [Occupied 'X', Occupied 'X', Occupied 'O', Empty, Occupied 'O', Occupied 'X', Empty, Occupied 'O', Occupied 'X']

teste4 = [Occupied 'X', Occupied 'X', Occupied 'X', Empty, Empty,
          Empty, Empty, Empty, Empty,Empty,
          Empty, Empty, Empty, Empty,Empty,
          Empty, Empty, Empty, Empty,Empty,
          Empty, Empty, Empty, Empty,Empty]

teste5 = [Occupied 'X', Occupied 'X', Occupied 'X', Empty, Empty,
          Empty, Empty, Empty, Empty,Empty,
          Empty, Empty, Empty, Occupied 'X',Empty,
          Empty, Empty, Empty, Empty,Empty,
          Empty, Empty, Empty, Empty,Empty]

teste6 = [Occupied 'X', Occupied 'X', Empty, Empty, Empty,
          Occupied 'X', Empty, Empty, Empty,Empty,
          Occupied 'X', Empty, Empty, Occupied 'X',Empty,
          Empty, Empty, Empty, Empty,Empty,
          Empty, Empty, Empty, Empty,Empty]

teste7 = [Occupied 'X', Occupied 'X', Empty, Empty, Empty,
          Empty, Occupied 'X', Empty, Empty,Empty,
          Empty, Empty, Occupied 'X', Occupied 'X',Empty,
          Empty, Empty, Empty, Empty,Empty,
          Empty, Empty, Empty, Empty,Empty]


teste8 = [Occupied 'X', Occupied 'X',   Occupied 'X',   Empty,          Empty,
          Occupied 'X', Empty,          Empty,          Empty,          Empty,
          Occupied 'X', Empty,          Occupied 'X',   Occupied 'X',   Empty,
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Empty,          Empty,          Empty,          Empty]


teste9 = [Occupied 'X', Occupied 'X',   Empty,          Empty,          Empty,
          Empty,        Occupied 'X',   Empty,          Empty,          Empty,
          Empty,        Empty,          Empty,          Occupied 'X',   Empty,
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Empty,          Empty,          Empty,          Empty]

teste10 = [
          Occupied 'X', Occupied 'X',   Occupied 'X',   Empty,          Empty,
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Occupied 'X',   Occupied 'X',   Occupied 'X',   Empty,
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Empty,          Empty,          Empty,          Empty]


teste11 = [
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Occupied 'X',   Occupied 'X',   Occupied 'X',   Empty,
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Empty,          Empty,          Empty,          Empty]

teste12 = [
          Empty,        Occupied 'X',   Empty,          Empty,          Empty,
          Empty,        Occupied 'X',   Empty,          Empty,          Empty,
          Empty,        Occupied 'X',   Empty,          Empty,          Empty,
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Empty,          Empty,          Empty,          Empty]

teste13 = [
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Occupied 'X',   Empty,          Empty,          Empty,
          Empty,        Occupied 'X',   Empty,          Empty,          Empty,
          Empty,        Occupied 'X',   Empty,          Empty,          Empty]

teste14 = [
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Empty,          Occupied 'X',   Empty,          Empty,
          Empty,        Occupied 'X',   Empty,          Empty,          Empty,
          Occupied 'X', Empty,          Empty,          Empty,          Empty,
          Empty,        Empty,          Empty,          Empty,          Empty]

teste15 = [
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Occupied 'X',   Occupied 'X',   Occupied 'X',   Empty,
          Empty,        Occupied 'X',   Empty,          Empty,          Empty,
          Empty,        Occupied 'X',   Empty,          Empty,          Empty]

teste16 = [
          Empty,        Empty,          Empty,          Empty,          Empty,
          Empty,        Occupied 'X',   Occupied 'X',   Empty,          Empty,
          Empty,        Occupied 'X',   Empty,          Empty,          Empty,
          Occupied 'X', Occupied 'X',   Empty,          Empty,          Empty,
          Empty,        Empty,          Empty,          Empty,          Empty]

teste17 = [
          Empty,        Empty,        Empty,          Empty,          Empty,
          Empty,        Empty,        Empty,          Occupied 'X',   Empty,
          Empty,        Empty,        Occupied 'X',   Empty,          Empty,
          Empty,        Occupied 'X', Occupied 'X',   Empty,          Empty,
          Empty,        Empty,        Occupied 'X',   Empty,          Empty]





















