module TableParser where

import Transform
import Text.ParserCombinators.ReadP
import Language.Haskell.Interpreter as I

isChar = (>' ')
charParser = many1 (satisfy isChar)
getParsed = readP_to_S charParser

getParsedWord' (h:str) [] = return (getParsed (h:str)) >>= getParsedWord' str
getParsedWord' _ (h:xs) = h:xs
getParsedWord' [] _ = []

getParsedWord'' [] = ("","")
getParsedWord'' list = last $ list

getParsedWord line = getParsedWord'' (getParsedWord' line [])

getWords' list (parsed,unparsed:ys) = return (getParsedWord $ unparsed:ys) >>= getWords' (if length parsed > 0 then (list++[parsed]) else [])
getWords' list (parsed,[]) = list++[parsed]

getWords line = getWords' [] ([],line)



mapLines = map getWords
mapQuotes = map ((\str->","++str).toStringList.encloseWithQuotes)

mapBraces list = "[" ++ (tail (unwords list)) ++ "]"

parse = mapBraces.mapQuotes.mapLines

printList (x:xs) = putStrLn x >> printList xs
printList [] = putStrLn ""

formatHeader = listToString.getWords

listToString = (\x-> drop 4 x).unwords.map ("    "++)

run functionStr processedArgs =
  do
    splits <- return (lines processedArgs)
    header <- return (head splits)
    unparsed <- return (tail splits)
    result <- runInterpreter $ setImports ["Prelude"] >> interpret (functionStr ++ " " ++ parse unparsed) (as :: [[String]])
    case result of
      (Right res) -> (putStrLn $ formatHeader header) >> printList (map listToString res)
      (Left err)   -> error $ show err



















