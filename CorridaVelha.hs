{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use when" #-}
module CorridaVelha (
    startGame
)
where

import Util

import Data.Type.Coercion (sym)


startGame::  [Char] -> [Int] -> (Int, Int) -> IO ()
startGame symbols movMachine dim = playRound (fst dim) [1..(fst dim)] symbols board dim movMachine
    where board = replicate (uncurry (*) dim) Empty

getPlayer:: Int -> String
getPlayer n = ["Jogador 1", "Jogador 2", "Jogador 3", "Jogador 4"] !! (n-1)

turnRotate :: [Int] -> [Int]
turnRotate lista = take (length lista) (drop 1 $ cycle lista)

printPlayer :: Int -> [Char] -> [Char]
printPlayer 0 _ = ""
printPlayer player symbols = printPlayer (player-1) symbols ++ [symbols !! (player-1)] ++ ": " ++ getPlayer player ++ "    "


playTurn:: Int -> [Int] -> [Char] -> [Cell] -> (Int, Int) -> [Int] -> IO (Int,[Cell])
playTurn player [] symbols board dim _ =  do
  putStrLn $ printPlayer player symbols ++ "\n"  
  putStrLn $ printBoard dim board
  return (0, board)
playTurn player turn symbols board dim movMachine = do
  putStrLn $ printPlayer player symbols ++ "\n"  
  putStrLn $ printBoard dim board
 
  putStrLn $ "\nTurno: " ++ getPlayer (head turn) ++ "."
  let syb = symbols !! (head turn-1)

  round <- roundPlayer syb board dim

  case round of
    Fail board -> do
      putStrLn "Inválido! Tente novamente."
      playTurn player turn symbols board dim movMachine
    Success newBoard pos-> do
      if isThereAWinner player syb newBoard then do
        putStrLn $ replicate 4 '\n' ++ printBoard dim newBoard
        putStrLn $ "Vencedor! " ++ getPlayer (head turn) ++ ": " ++ [syb] ++ " venceu!\n\n"
        return (1, newBoard)
      else do 
        playTurn player (tail turn) symbols newBoard dim movMachine



--[0,1,2,3,0,1,2,3]


-- player vai dizer se é 3 ou 4 jogadores
-- turn = [1,2,3,4] vai dizer dizer quem vai jogar, essa lista vai rotacionada
playRound :: Int -> [Int] -> String -> [Cell] -> (Int, Int) -> [Int] -> IO ()
playRound player turn symbols board dim movMachine = do 
  -- todos os jogadores fazem um movimento
  win <- playTurn player turn symbols board dim movMachine

  if fst win == 0
    then do
    -- maquina exclui coluna
    putStr "\nRodada dos jogares finalizada.\nPressione <Enter> atirar laser...\n\n"
    getChar
    newBoard <- roundMachine (snd win) dim movMachine
    -- chama playRound de novo
    playRound player (turnRotate turn) symbols newBoard dim (tail movMachine)
    else
      return ()
  


roundMachine:: [Cell] -> (Int,Int) -> [Int] -> IO [Cell]
roundMachine board dim moves  
  | head moves == 0 = do 
    putStrLn "Laser Pifou! Nenhuma coluna destruida!!\n"
    return board
  | otherwise = do
    putStrLn $ "Laser destruiu coluna " ++ show (head moves) ++ "!!"
    return $ deleteColumn (head moves) dim (snd dim) board

deleteColumn:: Int -> (Int, Int) -> Int -> [Cell] -> [Cell]
deleteColumn _ _ 0 board = board
deleteColumn delCol (xDim, yDim) i board = 
  deleteColumn delCol (xDim, yDim) (i-1) (transformeCell Empty  board xDim delCol i)


roundPlayer:: Char -> [Cell] -> (Int, Int) -> IO CellTransform
roundPlayer syb board dim = do
  putStrLn "Escolha a próxima coluna: "
  cell <- getInput
  if Occupied syb `elem`board
    then do
      let line = verifyNextLine dim board syb 
      return $ assignCell (cell, line-1) syb board dim
    else do
      let line = (snd dim)
      return $ assignCell (cell, line) syb board dim

getInput:: IO (Int)
getInput = do
  cell <- getLine
  let c = (read . pure :: Char -> Int) (head cell)
  return (c)


isThereAWinner :: Int -> Char -> [Cell] -> Bool -- ajeitar para 4 colunas
isThereAWinner player syb board 
  | player == 3 = (board !! 0 == Occupied syb) || (board !! 1 == Occupied syb) || (board !! 2 == Occupied syb)
  | otherwise = (board !! 0 == Occupied syb) || (board !! 1 == Occupied syb) || (board !! 2 == Occupied syb) || (board !! 3 == Occupied syb)


-- percorre lista de movimentos até encontrar um que estaja livre
verifyMove:: [Cell] -> Int -> [(Int,Int)] -> (Int, Int)
verifyMove board col moves = if verifyIsFree board col (head moves)
    then head moves
    else verifyMove board col (tail moves)

-- percorre lista e verifica proxima linha disponivel
verifyNextLine:: (Int, Int) -> [Cell] -> Char -> Int
verifyNextLine (xDim, yDim) board symb
  | Occupied symb `elem`(take xDim board) = 1
  | otherwise = 1 + verifyNextLine (xDim, yDim) (drop xDim board) symb
