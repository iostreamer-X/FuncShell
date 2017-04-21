module ArgumentParser where

-- This application has two flags -p and -h
data Flag = P | H
            deriving Show

data Arguments = Arguments 
     {flag :: Maybe Flag,
      parser :: Maybe String,
      function :: Maybe String
     } | None 
     deriving Show

stringToFlag :: String -> Maybe Flag
stringToFlag str
  | str == "-p"      = Just P
  | str == "-h"      = Just H
  | otherwise        = Nothing 

stringToParser :: String -> Maybe String
stringToParser str
  | length str > 0 = Just str
  | otherwise      = Nothing

stringToFunction :: String -> Maybe String
stringToFunction str
  | length str > 0 = Just str
  | otherwise      = Nothing


extractArguments :: [String]-> Arguments
--When just one argument is provided, so it's either a -h flag or the function
extractArguments (args:[]) = 
  case stringToFlag args of
    flag@(Just H) -> Arguments flag Nothing Nothing
    Nothing       -> Arguments Nothing Nothing (stringToFunction args)
    _             -> None 

extractArguments (flag:parser:function:[]) =  Arguments (stringToFlag flag) (stringToParser parser) (stringToFunction function)

extractArguments _ = None
