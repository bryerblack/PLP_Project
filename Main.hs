--P.L.P. - 2021.2
--Jogo da Velha

import Classico
import MarcaTres
import CorridaVelha

import System.Exit (exitSuccess)
import System.IO
import Control.Monad (forever)
import Control.Monad.Trans.Select (select)
import Data.Functor (void)
import System.Random (randomRIO)
import StringBuffer (StringBuffer(len))



main:: IO()
main = do
    let title = "---------- JOGO DA VELHA ----------"
    select <- startSelect title "" menu
    case select of
        1 -> do
            let titleGame = "---------- JOGO CLASSICO ----------"
            selectPlayer <- startSelect titleGame "Jogar contra:" ["Jogador", "Máquina"]
            selectSymbols <- startSelect titleGame "Deseja mudar os simbolos dos jogadores?" ["Sim", "Não"]

            movMachine <- shuffle $ createMove (3,3)

            if selectSymbols == 2
                then Classico.startGame selectPlayer "XO" movMachine
                else do
                    putStrLn "Digite os simbolos: "
                    syb <- getSymbol 2
                    let symbols = head syb : [last syb]
                    Classico.startGame selectPlayer symbols movMachine

            putStr "\nPressione <Enter> para continuar...\n\n"
            getChar
            main

        2 -> do
            let titleGame = "---------- JOGO MARCA-TRÊS ----------"
            selectPlayer <- startSelect titleGame "Jogar contra:" ["Jogador", "Máquina"]
            selectDim <- startSelect titleGame "Dimensão:" ["5x5", "7x7"]
            selectSymbols <- startSelect titleGame "Deseja mudar os simbolos dos jogadores?" ["Sim", "Não"]

            let dim = if selectDim == 1
                            then (5,5)
                            else (7,7)
            movMachine <- shuffle $ createMove dim
            powerShuffle <- shuffle [1..3]
            let pow = take 2 powerShuffle

            if selectSymbols == 2
                then MarcaTres.startGame selectPlayer "XO" movMachine dim pow
                else do
                    putStrLn "Digite os simbolos: "
                    syb <- getSymbol 2
                    let symbols = head syb : [last syb]
                    MarcaTres.startGame selectPlayer symbols movMachine dim pow

            putStr "\nPressione <Enter> para continuar...\n\n"
            getChar
            main

        3 -> do
            let titleGame = "---------- JOGO CORRIDA VELHA ----------"
            selectDim <- startSelect titleGame "Dimensão:" ["7x3 - 3 Jogadores", "9x4 - 4 Jogadores"]
            selectSymbols <- startSelect titleGame "Deseja mudar os simbolos dos jogadores?" ["Sim", "Não"]

            let dim@(x, y) = if selectDim == 1
                            then (3,7)
                            else (4,9)
            movMachine <- shuffle $ take (x*y) (cycle [0..x])
            powerShuffle <- shuffle $ take x (cycle [1..3])
            let pow = take x powerShuffle

            if selectSymbols == 2
                then CorridaVelha.startGame (take x "XOAY") movMachine dim pow
                else do
                    putStrLn "Digite os simbolos: "
                    syb <- getSymbol x
                    let symbols = syb
                    CorridaVelha.startGame symbols movMachine dim pow

            putStr "\nPressione <Enter> para continuar...\n\n"
            getChar
            main

        4 -> exitSuccess
        _ -> return ()


menu:: [String]
menu = ["Jogo Clássico",
        "Jogo Marca-Três",
        "Jogo Corrida Velha",
        "Sair"]


createScreen:: [Char] -> [Char] -> [Char] -> [Char]
createScreen strTitle strMsg strChoice =
    strTitle ++
    "\n\n w / s - mover cursor" ++
    replicate (10 - length(lines strChoice)) '\n' ++
    strMsg ++ "\n" ++
    strChoice ++
    replicate 3 '\n'

-- colocar a seta nas opçoes
printArrow:: Int -> [[Char]] -> Int -> [Char]
printArrow _ [] _  = []
printArrow i (x:xs) select = "  " ++ arrow i ++ x ++ "\n" ++ printArrow (i +1) xs select
    where arrow x = if x == select then "-> " else "  "

-- permitir apenas entradas validas 'w','s','\n'
getInput :: IO Char
getInput = do
    input <- getCh
    if input `elem` "ws\n" then return input else getInput

-- ler um caracter sem aparecer na tela
getCh :: IO Char
getCh = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    x <- getChar
    hSetEcho stdin True
    hSetBuffering stdin LineBuffering
    return x

-- Evitar escolha de simbolos iguais
getSymbol::Int -> IO String
getSymbol n = do
    syb <- getLine
    let symbols = [c | c <- syb, c /= ' ']
    if length symbols /= n
        then putStrLn "Quantidade errada de simbolos. Tente novamente." >> getSymbol n
        else if equalSyb symbols
            then putStrLn "Simbolos iguais. Tente novamente." >> getSymbol n
            else return symbols

equalSyb :: [Char] -> Bool
equalSyb [] = False
equalSyb (x:xs) = elem x xs || equalSyb xs

changeSelect:: Int -> Int -> Char -> Int
changeSelect nOfOpt select direction
    | direction == 'w' =  if select == 1 then nOfOpt else select - 1
    | otherwise = if select == nOfOpt then 1 else select + 1


startSelect::  [Char] -> [Char] -> [[Char]] -> IO Int
startSelect strTitle strMsg strChoice = selection strTitle strMsg (length strChoice) strChoice 1
    -- 1 serve para dizer que começa no primeiro index do menu

selection:: [Char] -> [Char] -> Int -> [[Char]] -> Int -> IO Int
selection strTitle strMsg nOfOpt strChoice select = do
    let screen = createScreen strTitle strMsg (printArrow 1 strChoice select)
                                        -- 1 serve para iniciar contagem
    putStr screen

    input <- getInput
    case input of
        '\n' -> return select
        _ -> let newSelect = changeSelect nOfOpt select input
                    in selection strTitle strMsg nOfOpt strChoice newSelect

createMove:: (Int, Int) -> [(Int, Int)]
createMove (xDim,yDim) = [(x,y) | x <- [1..xDim], y <- [1..yDim]]

shuffle :: [a] -> IO [a]
shuffle list = if length list < 2
        then return list
        else do
                i <- randomRIO (0, length list-1)
                newList <- shuffle (take i list ++ drop (i+1) list)
                return (list!!i : newList)
                -- [(1,2), (2,2), (1,1)]

