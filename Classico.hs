module Classico (
    startGame
)
where

import Util


startGame:: Int -> Int -> [Char] -> [(Int,Int)] -> IO ()
startGame player modo symbols movMachine
  | modo == 1 = playRound player 1 symbols board (3,3) movMachine   -- jogar modo normal
  | otherwise = putStrLn "modo insano: nao tem nada"                 -- jogar modo insano
    where board = replicate 9 Empty



-- ["Jogador 1", "Jogador 2"]
-- ["Jogador 1", "Maquina"]

getPlayer:: Int -> Int -> String
getPlayer pl turn
  | turn == 1 = "Jogador 1"
  | pl == 1 = "Jogador 2"     -- pl=1 e turn=2
  | otherwise = "Máquina"     -- pl=2 e turn=2



playRound :: Int -> Int -> String -> [Cell] -> (Int, Int) -> [(Int,Int)] -> IO ()
playRound player turn symbols board dim movMachine = do
  putStrLn $  [head symbols] ++ ": " ++ getPlayer player 1 ++ "    " ++
              [last symbols] ++ ": " ++ getPlayer player 2 ++ "\n"

  putStrLn $ printBoard dim board
  putStrLn $ "\nTurno: " ++ getPlayer player turn ++ "."

  let syb = if turn == 1 then head symbols else last symbols

  round <- if player == 2 && turn == 2
              then roundMachine syb board dim movMachine
              else roundPlayer syb board dim

  putStrLn $ replicate 4 '\n'

  case round of
    Fail board -> do
      putStrLn "Inválido! Tente novamente."
      playRound player turn symbols board dim movMachine
    Success newBoard -> do
      putStrLn $ printMsg dim (fst $ head movMachine)
      let newTurn = if turn == 1 then 2 else 1
      if isThereAWinner syb newBoard then do
        putStrLn $ replicate 4 '\n' ++ printBoard dim newBoard
        putStrLn $ "Vencedor! " ++ getPlayer player turn ++ ": " ++ [syb] ++ " venceu!\n\n"
        return ()
      else if checkBoardFree newBoard then do
        putStrLn $ replicate 4 '\n' ++ printBoard dim newBoard
        putStrLn "Empate!!\n\n"
        return ()
        else playRound player newTurn symbols newBoard dim (tail movMachine)


roundMachine:: Char -> [Cell] -> (Int, Int) -> [(Int, Int)] -> IO CellTransform
roundMachine syb board dim moves = do
  putStrLn "Movimento da máquina: "
  let cell = verifyMove board (fst dim) moves
  print cell
  return $ assignCell cell syb board dim

roundPlayer:: Char -> [Cell] -> (Int, Int) -> IO CellTransform
roundPlayer syb board dim = do
  putStrLn "Digitar dois números x y: "
  cell <- getInput
  return $ assignCell cell syb board dim


getInput:: IO (Int, Int)
getInput = do
  cell <- getLine
  let c = map (read . pure :: Char -> Int) (head cell : [last cell])
  return (head c,last c)


isThereAWinner :: Char -> [Cell] -> Bool
isThereAWinner syb board =
  or [
    -- check top row
    board !! 0 == (Occupied syb) && board !! 1 == (Occupied syb) && board !! 2 == (Occupied syb),
    -- check middle row
    board !! 3 == (Occupied syb) && board !! 4 == (Occupied syb) && board !! 5 == (Occupied syb),
    -- check bottom row
    board !! 6 == (Occupied syb) && board !! 7 == (Occupied syb) && board !! 8 == (Occupied syb),
    -- check left column
    board !! 0 == (Occupied syb) && board !! 3 == (Occupied syb) && board !! 6 == (Occupied syb),
    -- check middle column
    board !! 1 == (Occupied syb) && board !! 4 == (Occupied syb) && board !! 7 == (Occupied syb),
    -- check right column
    board !! 2 == (Occupied syb) && board !! 5 == (Occupied syb) && board !! 8 == (Occupied syb),
    -- check top left -> bottom right
    board !! 0 == (Occupied syb) && board !! 4 == (Occupied syb) && board !! 8 == (Occupied syb),
    -- check bottom left -> top right
    board !! 6 == (Occupied syb) && board !! 4 == (Occupied syb) && board !! 2 == (Occupied syb)
  ]

-- percorre lista de movimentos até encontrar um que estaja livre
verifyMove:: [Cell] -> Int -> [(Int,Int)] -> (Int, Int)
verifyMove board col moves = if verifyIsFree board col (head moves)
    then head moves
    else verifyMove board col (tail moves)