module DefaultParser where

import Transform
import Language.Haskell.Interpreter as I

parse :: String -> String
parse = toStringList.encloseWithQuotes.lines

run functionStr processedArgs = 
  do 
    result <- runInterpreter $ setImports ["Prelude"] >> interpret (functionStr ++ " " ++ processedArgs) (as :: [String])
    case result of 
      (Right res) -> putStrLn $ listToString res
      (Left err)   -> error $ show err

