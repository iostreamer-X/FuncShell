module ExternalParser where

import Language.Haskell.Interpreter as I

run :: String -> String -> String -> IO ()
run package functionStr args =
  do
    externalRunMaybe <- runInterpreter $ setImports ["Prelude",package] >> interpret "run" (as :: ([Char] -> String -> IO ()))
    case externalRunMaybe of 
      (Right externalRun) -> externalRun functionStr args
      (Left err) -> error $ show err 
