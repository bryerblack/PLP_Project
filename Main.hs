--P.L.P. - 2021.2
--Jogo da Velha

import TicTacToe 
import MarcaTres 
import CorridaVelha

import System.Exit (exitSuccess)
import System.IO
import Control.Monad (forever)
import Control.Monad.Trans.Select (select)
import Data.Functor (void)



main:: IO()
main = do
    let title = "---------- JOGO DA VELHA ----------"
    let symbols = "XO"
    select <- startSelect title menu
    case select of
        1 -> do
            let titleGame = "---------- JOGO CLASSICO ----------"
            selectPlayer <- startSelect titleGame ["Contra jogador", "Contra máquina"]
            selectModo <- startSelect titleGame ["Iniciar partida", "Modo insano"]

            TicTacToe.startGame selectPlayer selectModo symbols
            putStr "\nPressione <Enter> para continuar...\n\n"
            getChar
            main

        2 -> do
            let titleGame = "---------- JOGO MARCA-TRÊS ----------"
            selectPlayer <- startSelect titleGame ["Contra jogador", "Contra máquina"]
            selectModo <- startSelect titleGame ["Iniciar partida", "Modo insano"]

            MarcaTres.startGame selectPlayer selectModo symbols
            putStr "\nPressione <Enter> para continuar...\n\n"
            getChar
            main

        3 -> do
            let titleGame = "---------- JOGO CORRIDA VELHA ----------"
            selectPlayer <- startSelect titleGame ["Contra jogador", "Contra máquina"]
            selectModo <- startSelect titleGame ["Iniciar partida", "Modo insano"]

            CorridaVelha.startGame selectPlayer selectModo symbols
            putStr "\nPressione <Enter> para continuar...\n\n"
            getChar
            main

        4 -> do 
            putStr "\nNão tem nada\nPressione <Enter> para continuar...\n\n"
            getChar  
            main

        5 -> exitSuccess
        _ -> return () 


menu:: [String]
menu = ["Jogo Clássico",
        "Jogo Marca-Três",
        "Jogo Corrida Velha",
        "Mudar simbolo padrão",
        "Sair"]


createScreen:: [Char] -> [Char] -> [Char]
createScreen strTitle strChoice = strTitle ++
                                    "\n\n w / s - mover cursor" ++
                                    replicate (10 - length(lines strChoice)) '\n' ++
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

changeSelect:: Int -> Int -> Char -> Int
changeSelect nOfOpt select direction
    | direction == 'w' =  if select == 1 then nOfOpt else select - 1
    | otherwise = if select == nOfOpt then 1 else select + 1


startSelect::  [Char] -> [[Char]] -> IO Int
startSelect strTitle strChoice = selection strTitle (length strChoice) strChoice 1
    -- 1 serve para dizer que começa no primeiro index do menu

selection:: [Char] -> Int -> [[Char]] -> Int -> IO Int
selection strTitle nOfOpt strChoice select = do
    let screen = createScreen strTitle (printArrow 1 strChoice select)
                                        -- 1 serve para iniciar contagem
    putStr screen

    input <- getInput
    case input of
        '\n' -> return select
        _ -> let newSelect = changeSelect nOfOpt select input
                    in selection strTitle nOfOpt strChoice newSelect



