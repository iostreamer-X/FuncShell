module Main where
import Language.Haskell.Interpreter as I
import System.Environment

replace :: Char->Char->String->String
replace fromC toC = map (\c -> if c==fromC then toC else c)

encloseWithQuotes = map (\s->"\""++s++"\"")
listToString str = "[" ++ (init $ foldr (\s1 s2->s1++","++s2) "" str) ++ "]"

cleanFunction :: String->String
cleanFunction str = init.tail $ str

main = do functionPieces <- getArgs
          args <- getLine
          functionStr <- return (unwords functionPieces)
          processedArgs <- return $ listToString.encloseWithQuotes $ words args
          result <- runInterpreter $ setImports ["Prelude"] >> interpret (functionStr ++ " " ++ processedArgs) (as :: [String])
          case result of
            (Right res) -> print res
            (Left err)   -> error $ show err
