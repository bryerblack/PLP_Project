module CorridaVelha (
    startGame
)
where

import Util
    ( Cell(..),
      CellTransform(..),
      printBoard,
      checkBoardFree,
      verifyIsFree,
      assignCell)

startGame:: Int -> Int -> [Char] -> IO ()
startGame b c d =  putStrLn "nao tem nada"