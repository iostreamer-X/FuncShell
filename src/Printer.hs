module Printer where

printList :: Either String [String] -> IO ()
printList (Right (x:xs)) = putStrLn x >> printList (Right xs)
printList (Right []) = return ()

printList (Left err) = error err
