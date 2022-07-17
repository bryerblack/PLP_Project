module MarcaTres (
    startGame
)
where

import Util
import GHC.Integer.GMP.Internals (powModBigNat)
import PowerUps

startGame:: Int -> [Char] -> [(Int,Int)] -> (Int, Int) -> [Int] -> IO ()
startGame player symbols movMachine dim pow = playRound player 1 symbols board dim movMachine (0,0) pow
    where board = replicate (uncurry (*) dim) Empty



-- ["Jogador 1", "Jogador 2"]
-- ["Jogador 1", "Maquina"]

getPlayer:: Int -> Int -> String
getPlayer pl turn
  | turn == 1 = "Jogador 1"
  | pl == 1 = "Jogador 2"     -- pl=1 e turn=2
  | otherwise = "Máquina"     -- pl=2 e turn=2

getPower:: Int -> Int -> [Int] -> String
getPower pl turn pow
  | turn == 1 = show $ powerName (head pow)
  | pl == 1 = show $ powerName (last pow)
  | otherwise = "Mech"

powerName:: Int -> String
powerName pow
  | pow == 1 = "Remove Jogada"
  | pow == 2 = "Blip"
  | pow == 3 = "Lupin"
  | otherwise = "Indisponível"

playRound :: Int -> Int -> String -> [Cell] -> (Int, Int) -> [(Int,Int)] -> (Int, Int) -> [Int] -> IO ()
playRound player turn symbols board dim movMachine score@(p1, p2) power = do
  putStrLn $  [head symbols] ++ ": " ++ getPlayer player 1 ++ "    " ++
              [last symbols] ++ ": " ++ getPlayer player 2 ++ "\n" ++
              [head symbols] ++ ": " ++ show p1 ++ "    " ++
              [last symbols] ++ ": " ++ show p2 ++ "\n"

  putStrLn $ printBoard dim board
  putStrLn $ "\nTurno: " ++ getPlayer player turn ++ "."
  putStrLn $ "Power: " ++ getPower player turn power ++ "."

  let syb = if turn == 1 then head symbols else last symbols
  let pow = if turn == 1 then head power else last power

  round <- if player == 2 && turn == 2
              then roundMachine syb board dim movMachine
              else roundPlayer syb board dim pow

  putStrLn $ replicate 4 '\n'

  case round of
    Fail board -> do
      putStrLn "Inválido! Tente novamente."
      playRound player turn symbols board dim movMachine score power
    Success newBoard pos -> do
      putStrLn $ printMsg dim (fst $ head movMachine)
      let newTurn = if turn == 1 then 2 else 1
      let newScore = if turn == 1 
          then (checkPoint board (fst dim) syb pos + p1 , p2)
          else (p1, checkPoint board (fst dim) syb pos + p2)

      if checkBoardFree newBoard then do
        putStrLn $ replicate 4 '\n' ++ printBoard dim newBoard

        if  p1 > p2 
          then putStrLn $ "Vencedor! " ++ getPlayer player 1 ++ ": " ++ [syb] ++ " venceu!\n\n"
          else if p2 > p1 
            then putStrLn $ "Vencedor! " ++ getPlayer player 2 ++ ": " ++ [syb] ++ " venceu!\n\n"
            else putStrLn "Empate!!\n\n"

        return ()
      else playRound player newTurn symbols newBoard dim (tail movMachine) newScore power


roundMachine:: Char -> [Cell] -> (Int, Int) -> [(Int, Int)] -> IO CellTransform
roundMachine syb board dim moves = do
  putStrLn "Movimento da máquina: "
  let cell = verifyMove board (fst dim) moves
  print cell
  return $ assignCell cell syb board dim

roundPlayer:: Char -> [Cell] -> (Int, Int) -> Int -> IO CellTransform
roundPlayer syb board dim pow = do
  putStrLn "00 para usar Power-Up"
  putStrLn "Digitar dois números x y: "
  cell <- getInput
  if cell == (0,0)
    then usePower pow syb board dim
    else return $ assignCell cell syb board dim


getInput:: IO (Int, Int)
getInput = do
  cell <- getLine
  let c = map (read . pure :: Char -> Int) (head cell : [last cell])
  return (head c,last c)


-- percorre lista de movimentos até encontrar um que estaja livre
verifyMove:: [Cell] -> Int -> [(Int,Int)] -> (Int, Int)
verifyMove board col moves = if verifyIsFree board col (head moves)
    then head moves
    else verifyMove board col (tail moves)


sides:: Int -> Int -> ([(Int,Int)],[(Int,Int)])
sides x y = ([(x-1,y), (x+1,y), (x,y-1), (x,y+1), (x-1,y-1), (x+1,y+1), (x+1,y-1), (x-1,y+1)],
             [(x-2,y), (x+2,y), (x,y-2), (x,y+2), (x-2,y-2), (x+2,y+2), (x+2,y-2), (x-2,y+2)])

-- verifica se tem peças cercando a posição
middle:: [Cell] -> Int -> Char -> [(Int,Int)] -> Int
middle board dim syb [] = 0
middle board dim syb list@(x:xs) =
    if (checkPos x (dim,dim) && checkPos (head xs) (dim,dim)) && {-verifica se posição passada é valida-}
        (setCell board dim x == Occupied syb && setCell board dim (head xs) == Occupied syb)
        then 1 + middle board dim syb (drop 2 list)
        else 0 + middle board dim syb (drop 2 list)


-- verifica se tem peças adjacentes a posição 
checkSides:: [Cell] -> Int -> Char -> ([(Int,Int)],[(Int,Int)]) -> Int
checkSides board dim syb ([],[]) = 0
checkSides board dim syb (l1,l2) =
    if (checkPos (head l1) (dim,dim) && checkPos (head l2) (dim,dim)) && {-verifica se posição passada é valida-}
        ((setCell board dim (head l1) == Occupied syb) && (setCell board dim (head l2) == Occupied syb)) 
        then 1 + checkSides board dim syb (drop 1 l1, drop 1 l2) 
        else 0 + checkSides board dim syb (drop 1 l1, drop 1 l2)


checkPoint :: [Cell] -> Int -> Char -> (Int, Int) -> Int
checkPoint board dim syb (xPos, yPos) = checkSides board dim syb (sides xPos yPos) + middle board dim syb (fst $ sides xPos yPos)


usePower:: Int -> Char -> [Cell] -> (Int, Int) -> IO CellTransform
usePower power syb board dim = do
  case power of
    1 -> do 
      putStrLn "Digite a posição a ser apagada: "
      pos <- getInput 
      return(removeJogada syb pos board dim)
    2 -> do
      return(blip board dim)
    3 -> do
      putStrLn "Digite a posição a ser furtada: "
      pos <- getInput
      return(lupin syb pos board dim) 
    _ -> return(Fail board)
