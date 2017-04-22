module Transform where

-- The output of the bash command is converted to a list of strings
-- and this list needs to represented as a String to be interpreted.
-- To do this, each string in the list is enclosed with quotes
-- and then joined together to get string representation of list.
--
-- The way this is achieved is each string in list is mapped to {,"str"},
-- so ["1","2"] becomes [ ",\"1\"" , ",\"2\"" ]
-- Now all that is left is join the list, hence unwords, but we get a leading {,}
-- hence `tail` 

encloseWithQuotes :: [String] -> [String]
encloseWithQuotes = map (\s->",\""++s++"\"")

toStringList :: [String] -> String
toStringList str = "[" ++ (tail.unwords $ str) ++ "]"

