module TableParser where

import Transform
import Text.ParserCombinators.ReadP
import Language.Haskell.Interpreter as I

isChar = (>' ')

charParser :: ReadP [Char]
charParser = many1 (satisfy isChar)

-- This parses characters till a space is encountered
getParsed :: ReadS [Char]
getParsed = readP_to_S charParser

-- Leading space needs to be removed or else our parser will output []
removeLeadingSpace (' ':xs) = removeLeadingSpace xs
removeLeadingSpace str = str

-- Only the last element is of interest, rest are incomplete
getPair :: [Char] -> ([Char], [Char])
getPair line = 
  parsedPair $ getParsed.removeLeadingSpace $ line
  where
    parsedPair list@(x:xs) = last list
    parsedPair [] = ("","")

{-
 - When we run getPair on a string, we get a pair of strings.
 - The first half is parsed, the second half failed our parser.
 - The second half failed because it had leading space, so if we run getPair on
 - the unparsed string, it will ultimately be parsed.
 -
 - And that is the solution presented here, we run getPair,
 - pick the parsed part and put it in a list, and run getPair on unparsed part.
 - We do this till unparsed is [] ie empty and then we return the list of parsed words.
 -}

getWords' :: [[Char]] -> ([Char], [Char]) -> [[Char]]
getWords' list (parsed,[]) = list++[parsed]
getWords' list (parsed,unparsed) = return (getPair $ unparsed) >>= getWords' (if length parsed > 0 then (list++[parsed]) else [])

getWords :: [Char] -> [[Char]]
getWords line = getWords' [] ([],line)


mapLines :: [[Char]] -> [[[Char]]]
mapLines = map getWords

mapQuotes :: [[String]] -> [[Char]]
mapQuotes = map ((\str->","++str).toStringList.encloseWithQuotes)

mapBraces :: [String] -> [Char]
mapBraces list = "[" ++ (tail (unwords list)) ++ "]"

parse :: [[Char]] -> [Char]
parse = mapBraces.mapQuotes.mapLines

printList (x:xs) = putStrLn x >> printList xs
printList [] = putStrLn ""

formatHeader = listToString.getWords

listToString :: [[Char]] -> [Char]
listToString = (\x-> drop 4 x).unwords.map ("    "++)

run :: [Char] -> String -> IO ()
run functionStr processedArgs =
  do
    splits <- return (lines processedArgs)
    header <- return (head splits)
    unparsed <- return (tail splits)
    result <- runInterpreter $ setImports ["Prelude"] >> interpret (functionStr ++ " " ++ parse unparsed) (as :: [[String]])
    case result of
      (Right res) -> (putStrLn $ formatHeader header) >> printList (map listToString res)
      (Left err)   -> error $ show err



















