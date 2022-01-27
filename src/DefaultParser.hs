module DefaultParser(run, runGeneric)  where

import Transform
import qualified Language.Haskell.Interpreter as I
import Data.Data (Typeable)
import Data.List (uncons)

-- Interpret functionStr and apply the result on stdinStr. 
runGeneric :: Typeable t => (t -> String -> String) -> String -> String -> IO ()
runGeneric applyOnStr functionStr stdinStr = do 
  result <- I.runInterpreter $ I.setImports ["Prelude"] >> I.interpret functionStr I.infer
  case result of
    (Right res) -> putStr . applyOnStr res $ stdinStr
    (Left err)   -> error $ show err

strAsLines :: ([String] -> [String]) -> String -> String
strAsLines f = unlines . f . lines

runDefault :: String -> String -> IO ()
runDefault = runGeneric strAsLines

-- Interpret functionStr as function :: [String] -> [String] and apply it stdinStr.
run = runDefault
