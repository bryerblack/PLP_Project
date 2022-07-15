import Util
    ( assignCell,
      checkBoardFree,
      printBoard,
      verifyIsFree,
      Cell(..),
      CellTransform(..),
      printMsg,
      transformeCell )

removeJogada:: Char -> [Cell] -> (Int, Int) -> IO CellTransform
removeJogada syb board dim = do
  putStrLn "Digite a posição a remover: "
  cell <- getLine
  return $ transformeCell Empty board 1 cell 0x1

blip:: [Cell] -> (Int, Int) -> [Cell]
blip board dim = do
    replicate (uncurry (*) dim) Empty