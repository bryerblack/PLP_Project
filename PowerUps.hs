import Util
    ( assignCell,
      checkBoardFree,
      printBoard,
      verifyIsFree,
      Cell(..),
      CellTransform(..),
      printMsg,
      transformeCell )

removeJogada:: Char -> [Cell] -> Int -> (Int, Int) -> [Cell]
removeJogada syb board col dim = do
  putStrLn "Digite a posição a remover: "
  transformeCell Empty board col <$> getLine

blip:: [Cell] -> (Int, Int) -> [Cell]
blip board dim = do
    replicate (uncurry (*) dim) Empty

