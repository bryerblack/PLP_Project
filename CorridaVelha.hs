module CorridaVelha (
    startGame
)
where

import Util
    ( assignCell,
      checkBoardFree,
      printBoard,
      verifyIsFree,
      Cell(..),
      CellTransform(..),
      printMsg )


startGame:: Int -> Int -> [Char] -> [(Int,Int)] -> (Int, Int) -> IO ()
startGame player modo symbols movMachine dim
  | modo == 1 = playRound player 1 symbols board dim movMachine   -- jogar modo normal
  | otherwise = putStrLn "modo insano: nao tem nada"                 -- jogar modo insano
    where board = replicate (uncurry (*) dim) Empty

getPlayer:: Int -> Int -> String
getPlayer player turn
  | turn == 1 = "Jogador 1"
  | turn == 2 = "Jogador 2"     -- pl=1 e turn=2
  | otherwise = "Jogador 3"


playRound :: Int -> Int -> String -> [Cell] -> (Int, Int) -> [(Int,Int)] -> IO ()
playRound player turn symbols board dim movMachine = do
  putStrLn $  [head symbols] ++ ": " ++ getPlayer player 1 ++ "    " ++
              [symbols !! 1] ++ ": " ++ getPlayer player 2 ++ "    " ++
              [last symbols] ++ ": " ++ getPlayer player 3 ++ "\n"

  putStrLn $ printBoard dim board
  putStrLn $ "\nTurno: " ++ getPlayer player turn ++ "."

  let syb
        | turn == 1 = head symbols
        | turn == 2 = symbols !! 1
        | otherwise = last symbols

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
      let newTurn
            | turn == 1 = 2
            | turn == 2 = 3
            | otherwise = 1
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
  putStrLn "Digite a posição: " 
  cell <- getInput
  return $ assignCell cell syb board dim

getInput:: IO (Int, Int)
getInput = do
  cell <- getLine
  let c = map (read . pure :: Char -> Int) (head cell : [last cell])
  return (head c,last c)

isThereAWinner :: Char -> [Cell] -> Bool
isThereAWinner syb board = (board !! 18 == Occupied syb) || (board !! 19 == Occupied syb) || (board !! 20 == Occupied syb)

-- percorre lista de movimentos até encontrar um que estaja livre
verifyMove:: [Cell] -> Int -> [(Int,Int)] -> (Int, Int)
verifyMove board col moves = if verifyIsFree board col (head moves)
    then head moves
    else verifyMove board col (tail moves)