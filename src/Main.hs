module Main where
import Language.Haskell.Interpreter as I
import System.Environment

-- The output of the bash command is converted to a list of strings
-- and this list needs to represented as a String to be interpreted.
-- To do this, each string in the list is enclosed with quotes
-- and then joined together to get string representation of list.

-- The way this is achieved is each string in list is mapped to {,"str"},
-- so ["1","2"] becomes [ ",\"1\"" , ",\"2\"" ]
-- Now all that is left is join the list, hence unwords, but we get a leading {,}
-- hence `tail` 
encloseWithQuotes = map (\s->",\""++s++"\"")
listToString str = "[" ++ (tail.unwords $ str) ++ "]"

main = do functionPieces <- getArgs
          args <- getContents
          functionStr <- return (unwords functionPieces)
          processedArgs <- return $ listToString.encloseWithQuotes $ words args
          result <- runInterpreter $ setImports ["Prelude"] >> interpret (functionStr ++ " " ++ processedArgs) (as :: [String])
          case result of
            (Right res) -> print res
            (Left err)   -> error $ show err
