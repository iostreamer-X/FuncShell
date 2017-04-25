module ExternalParser where

import Transform 
import Language.Haskell.Interpreter as I

run parser functionStr args = 
  do 
    result <- runInterpreter $ setImports ["Prelude",parser] >> interpret ("run " ++ (show functionStr) ++ " " ++ (show args) ++ "") (as :: IO ())
    case result of
      (Right action) -> action
      (Left err)   -> error $ show err
