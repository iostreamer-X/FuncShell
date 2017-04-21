module Main where

import ArgumentParser
import System.Environment
import System.Exit

showHelp = 
  do 
    putStrLn "\nusage  : -h To get this help message."
    putStrLn "           -p <parser name> To choose your parser."
    putStrLn "           <your function> To use default parser.\n\n"
    putStrLn "examples : ls |- -p myParser \'map(\"prepend \"++)\'"
    putStrLn "           ls |- \'map(++\"append \")\'"

interpret parser function = 
  do
    print parser
    print function
    print "interpreting"

mapArgToIO :: Arguments -> IO ()	
mapArgToIO argument = 
  case argument of 
    Arguments (Just H)  _  _ -> showHelp
    Arguments  (Just P) (Just parser) (Just function) -> interpret parser function
    Arguments Nothing Nothing (Just function) -> interpret "smh" function
    _ -> putStrLn "Invalid arguments!" >> showHelp >> exitFailure

processArguments args = mapArgToIO (extractArguments args)

main = getArgs >>= processArguments
