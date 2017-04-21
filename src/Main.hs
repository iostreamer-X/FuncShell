module Main where

import ArgumentParser
import System.Environment

showHelp = print "Help\n"
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
    _ -> error "Bitches be balling"

processArguments args = mapArgToIO (extractArguments args)

main = getArgs >>= processArguments
