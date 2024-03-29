import Data.List.Split (splitOn)

main :: IO ()

main = do
  fileInput <- readFile "input.txt"
  let parsedInput = (read :: String -> Int) <$> splitOn "," (init fileInput)
  let modInput = changeAt 1 12 $ changeAt 2 2 parsedInput
  print (head $ execProgram modInput 0)

changeAt :: Int -> a -> [a] -> [a]
changeAt n a list = (\(l, _:xs) -> l ++ a:xs) $ splitAt n list

execOpCode :: Int -> Int -> [Int] -> [Int]
execOpCode 1 at source = changeAt loc (lhs + rhs) source
  where lhs = source !! (source !! (at + 1))
        rhs = source !! (source !! (at + 2))
        loc = source !! (at + 3)
        
execOpCode 2 at source = changeAt loc (lhs * rhs) source
  where lhs = source !! (source !! (at + 1))
        rhs = source !! (source !! (at + 2))
        loc = source !! (at + 3)

execProgram :: [Int] -> Int -> [Int]
execProgram source opPos
  | opcode == 99 = source
  | otherwise = execProgram (execOpCode opcode opPos source) nextOp
  where opcode = source !! opPos
        nextOp = opPos + 4
