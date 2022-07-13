module Util (
    CellTransform(..),
    Cell(..),
    printBoard,
    transformeCell,
    assignCell,
    checkBoardFree
)
where

import Data.List (intercalate)
import Data.Type.Coercion (sym)
import System.Random


data CellTransform = Success String [Cell] | Fail String [Cell]

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

checkBoardFree::[Cell] -> Bool
checkBoardFree board = Empty `notElem` board

verifyIsFree::  [Cell] -> Int -> Int -> Int -> Bool
verifyIsFree board _ xPos 1 = board !! (xPos-1) == Empty
verifyIsFree board col xPos yPos = verifyIsFree (drop col board) col xPos (yPos-1)

-- faz a substituição da peça
transformeCell:: Char -> [Cell] -> Int -> Int -> Int -> [Cell]
transformeCell syb board _ xPos 1 = take (xPos-1) board ++ [Occupied syb] ++ drop xPos board
transformeCell syb board col xPos yPos = take col board ++ transformeCell syb (drop col board) col xPos (yPos-1)

-- faz a verificação do espaço vazio e a substituição da peça
assignCell:: (Int, Int) -> Char -> [Cell] -> (Int, Int) -> CellTransform
assignCell (xPos, yPos) symbol board (col, lin)=
    if verifyIsFree board col xPos yPos 
            then Success randomMessage (transformeCell symbol board col xPos yPos) 
            else Fail "Inválido!" board

randomMessage:: String
randomMessage = "OK!"
