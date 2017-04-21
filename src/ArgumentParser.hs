module ArgumentParser where

import Text.ParserCombinators.ReadP

data Flag = P | H
            deriving Show

data Arguments = Arguments 
     {flag :: Maybe Flag,
      parser :: Maybe String,
      function :: Maybe String
     }
     deriving Show

stringToFlag :: String -> Maybe Flag
stringToFlag str
  | str == "-p"      = Just P
  | str == "-h"      = Just H
  | otherwise = Nothing 

stringToParser :: String -> Maybe String
stringToParser str
  | length str > 0 = Just str
  | otherwise        = Nothing

stringToFunction :: String -> Maybe String
stringToFunction str
  | length str > 0 = Just str
  | otherwise        = Nothing


extractArguments :: [String]->Maybe Arguments
extractArguments (args:[]) = 
  case stringToFlag args of
    flag@(Just H) -> Just $ Arguments flag Nothing Nothing
    Nothing       -> Just $ Arguments Nothing Nothing (stringToFunction args)
    _             -> Nothing  

extractArguments (flag:parser:function:[]) =  Just $ Arguments (stringToFlag flag) (stringToParser parser) (stringToFunction function)

extractArguments _ = Nothing
