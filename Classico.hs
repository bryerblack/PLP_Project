module Classico (
    startGame
)
where

import Util


startGame:: Int -> Int -> [Char] -> IO ()
startGame player modo symbols 
  | modo == 1 = playRound player 1 symbols board (3,3)      -- jogar modo normal
  | otherwise = putStrLn "modo insano: nao tem nada"        -- jogar modo insano
    where board = replicate 9 Empty



-- ["Jogador 1", "Jogador 2"]
-- ["Jogador 1", "Maquina"]

getPlayer:: Int -> Int -> String
getPlayer pl turn 
  | turn == 1 = "Jogador 1"
  | pl == 1 = "Jogador 2"     -- pl=1 e turn=2
  | otherwise = "Máquina"     -- pl=2 e turn=2



playRound :: Int -> Int -> String -> [Cell] -> (Int, Int) -> IO ()
playRound player turn symbols board dim = do
  putStrLn $  replicate 4 '\n' ++
              [head symbols] ++ ": " ++ getPlayer player 1 ++ "    " ++ 
              [last symbols] ++ ": " ++ getPlayer player 2 ++ "\n"

  putStrLn $ printBoard dim board

  putStrLn $ "\nTurno: " ++ getPlayer player turn ++ "."
  putStrLn "Digitar dois números x y: "
  cell <- getInput
    
  let syb = if turn == 1 then head symbols else last symbols

  case assignCell cell syb board dim of
    Fail err board -> do
      putStrLn err
      playRound player turn symbols board dim

    Success msg newBoard -> do
      let newTurn = if turn == 1 then 2 else 1
      if isThereAWinner syb newBoard then do
        putStrLn $ replicate 4 '\n' ++ printBoard dim newBoard
        putStrLn $ "Vencedor! " ++ getPlayer player turn ++ " " ++ [syb] ++ " venceu!\n\n"
        return ()
      else putStrLn msg >> playRound player newTurn symbols newBoard dim


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


