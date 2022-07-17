module PowerUps where

import Util
    ( assignCell,
      checkBoardFree,
      printBoard,
      verifyIsFree,
      Cell(..),
      CellTransform(..),
      printMsg,
      transformeCell,
      checkPos)

removeJogada:: Char -> (Int, Int) -> [Cell] -> (Int, Int) -> CellTransform
removeJogada symbol pos@(xPos, yPos) board dim@(col, lin) = do
  if checkPos pos dim && not (verifyIsFree board col (xPos, yPos))
    then Success (transformeCell (Empty) board col xPos yPos) (xPos, yPos)
    else Fail board

blip:: [Cell] -> (Int, Int) -> CellTransform
blip board dim = Success (replicate (uncurry (*) dim) Empty) dim

lupin:: Char -> (Int, Int) -> [Cell] -> (Int, Int) -> CellTransform
lupin symbol pos@(xPos, yPos) board dim@(col, lin) = do
  if checkPos pos dim && not (verifyIsFree board col (xPos, yPos))
        then Success (transformeCell (Occupied symbol) board col xPos yPos) (xPos, yPos)
        else Fail board
