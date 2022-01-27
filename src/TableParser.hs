module TableParser where

import Data.List ( uncons, transpose )
import DefaultParser (runGeneric)
import Data.Maybe (fromJust)

--  Adds padding to each string from the list such that length of each string after padding is same.
addTrailingSpaces :: [String] -> [String]
addTrailingSpaces strList = [s ++ (replicate (n+k) ' ') | s <- strList, let n = (length (maximum strList) - length s), let k = 6]

strAsTableAligned :: ([[String]] -> [[String]]) -> String -> String
strAsTableAligned f str = unlines output
  where
    (header, table) = fromJust . uncons . map words . lines $ str
    res = f table
    outputMatrix = transpose $ (if length header == length (head res) then header else []) : res
    paddedMatrix = map addTrailingSpaces outputMatrix
    output = map unwords $ transpose paddedMatrix
  
runTable :: String -> String -> IO ()
runTable = runGeneric strAsTableAligned

run = runTable
