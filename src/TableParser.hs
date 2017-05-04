module TableParser where

import Transform
import Text.ParserCombinators.ReadP
import Language.Haskell.Interpreter as I
import Data.List

--- PARSING

isChar = (>' ')

charParser :: ReadP String
charParser = many1 (satisfy isChar)

-- This parses characters till a space is encountered
getParsed :: ReadS String
getParsed = readP_to_S charParser

-- Leading space needs to be removed or else our parser will output []
removeLeadingSpace (' ':xs) = removeLeadingSpace xs
removeLeadingSpace str = str

-- Only the last element is of interest, rest are incomplete
getPair :: String -> (String, String)
getPair line =
  parsedPair $ getParsed.removeLeadingSpace $ line
  where
    parsedPair list@(x:xs) = last list
    parsedPair [] = ("","")

{-
 - When we run getPair on a string, we get a pair of strings. (:/)
 - The first half is parsed, the second half failed our parser.
 - The second half failed because it had leading space, so if we run getPair on
 - the unparsed string, it will ultimately be parsed.
 -
 - And that is the solution presented here, we run getPair,
 - pick the parsed part and put it in a list, and run getPair on unparsed part.
 - We do this till unparsed is [] ie empty and then we return the list of parsed words.
 -}

getWords' :: [String] -> (String, String) -> [String]
getWords' list (parsed,[]) = list++[parsed]
getWords' list (parsed,unparsed) = return (getPair $ unparsed) >>= getWords' (if length parsed > 0 then (list++[parsed]) else [])

getWords :: String -> [String]
getWords line = getWords' [] ([],line)


escapeChar :: Char -> String
escapeChar '\\' = "\\\\"
escapeChar c   = [c]

--- END PARSING

--- TRANSFORMING
mapEscape :: [String] -> [String]
mapEscape = map (>>= escapeChar)

mapLines :: [String] -> [[String]]
mapLines = map getWords

mapQuotes :: [[String]] -> [String]
mapQuotes = map ((\str->","++str).toStringList.encloseWithQuotes)

mapBraces :: [String] -> String
mapBraces list = "[" ++ (tail (unwords list)) ++ "]"

parse :: [String] -> String
parse = mapBraces.mapQuotes.mapLines.mapEscape

--- END TRANSFORMING

--- EXECUTING

printList (x:xs) = putStrLn x >> printList xs
printList [] = return ()


--  Adds padding to each string from the list such that length of each string after padding is same.
addTrailingSpaces :: [String] -> [String]
addTrailingSpaces strList = [s ++ (replicate (n+k) ' ') | s <- strList, let n = (length (maximum strList) - length s), let k = 6]


run :: String -> String -> IO ()
run functionStr processedArgs =
  do
    splits <- return (lines processedArgs)
    header <- return (head splits)
    unparsed <- return (tail splits)
    result <- runInterpreter $ setImports ["Prelude"] >> interpret (functionStr ++ " " ++ parse unparsed) (as :: [[String]])
    case result of
      (Left err)  -> error $ show err
      (Right [])  -> putStrLn header
      (Right res) ->
        do
          outputMatrix <- return $ transpose $ (if length (getWords header) == length (head res) then getWords header else []) : res
          paddedMatrix <- return $ map addTrailingSpaces outputMatrix
          output <- return $ map unwords $ transpose paddedMatrix
          printList output

--- END EXECUTING
