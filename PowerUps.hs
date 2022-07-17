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

removeJogada:: (Int, Int) -> Char -> [Cell] -> (Int, Int) -> CellTransform
removeJogada pos@(xPos, yPos) symbol board dim@(col, lin)=
    if checkPos pos dim && verifyIsFree board col (xPos, yPos)
        then Success (transformeCell (Empty) board col xPos yPos) (xPos, yPos)
        else Fail board

blip:: [Cell] -> (Int, Int) -> [Cell]
blip board dim = do
    replicate (uncurry (*) dim) Empty

lupin:: (Int, Int) -> Char -> [Cell] -> (Int, Int) -> CellTransform
lupin pos@(xPos, yPos) symbol board dim@(col, lin)=
  if checkPos pos dim && not (verifyIsFree board col (xPos, yPos))
        then Success (transformeCell (Occupied symbol) board col xPos yPos) (xPos, yPos)
        else Fail board