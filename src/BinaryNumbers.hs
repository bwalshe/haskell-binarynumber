{-|
Module      : BinaryNumbers
Description : A fairly pointless exercise in representing non-negative integers 
              as collections ofbinary digits.
Copyright   : (c) Brian Walshe, 2018

I created this module while trying to remind myself how Haskell works. The basic
idea is to represent non-negative numbers as binary digits and define equality,
addtion, etc as operations on the individual bits.
-}
module BinaryNumbers(
    BinaryNumber,
    stringToBinary,
    (|+|)
) where

-- Binary digits are either One or Zero
data BinaryDigit = One | Zero deriving (Eq)

-- Display digits ussing the characters '1' and '0'
instance Show BinaryDigit where
    show One = "1"
    show Zero = "0"

-- Attempt to convert a char into a digit. Only defined on '1' and '0'.
charToBinary :: Char -> Maybe BinaryDigit
charToBinary c 
    | c == '1' = Just One
    | c == '0' = Just Zero
    | otherwise = Nothing

-- A binary number is a sequence of digits
data BinaryNumber = BinaryNumber [BinaryDigit]

-- Leading Zeros do not change the value of the number, so this funciton 
-- can be used to remove them.
normalize :: BinaryNumber -> BinaryNumber
normalize (BinaryNumber digits) = BinaryNumber (dropWhile (==Zero) digits)


-- Convert a string to a binary number. Fails if the string contains any
-- chars other than '1' opr '0'
stringToBinary :: String -> Maybe BinaryNumber
stringToBinary s = fmap BinaryNumber  (sequence ( map charToBinary s))

-- pad the number's digits to be at least `n` long
pad :: Int -> [BinaryDigit] -> [BinaryDigit]
pad n digits = (replicate p Zero) ++ digits
    where p = max 0 (n - length digits)

-- Display the number using the shortest number of characters possible
instance Show BinaryNumber where
    show number = concat $ map show digits
        where (BinaryNumber digits) = normalize number

-- test for equallity
instance Eq BinaryNumber where
    a == b = aNorm == bNorm
        where (BinaryNumber aNorm) = normalize a
              (BinaryNumber bNorm) = normalize b

-- Used by the |+| function. Takes a carry in and a pair of digits, and priduces 
-- a pair containing the result and the carry out
addWithCarry :: BinaryDigit -> (BinaryDigit, BinaryDigit) -> (BinaryDigit, BinaryDigit)
addWithCarry Zero (Zero, Zero) = (Zero, Zero)
addWithCarry Zero (One, Zero) = (One, Zero)
addWithCarry Zero (Zero, One) = (One, Zero)
addWithCarry Zero (One, One) = (Zero, One)
addWithCarry One (Zero, Zero) = (One, Zero)
addWithCarry One (Zero, One)= (Zero, One)
addWithCarry One (One, Zero) = (Zero, One)
addWithCarry One (One, One)= (One, One)

-- Used by |+|. Add two lists of digits, assuming the lists are the same length and 
-- that the least siginificant digit is on the right
addReversedDigits :: BinaryDigit -> [(BinaryDigit, BinaryDigit)] -> [BinaryDigit]
addReversedDigits c [] = [c]
addReversedDigits c (a:rest) = (fst r) : (addReversedDigits (snd r) rest)
    where r = addWithCarry c a

-- Add two binary numbers together.
(|+|) :: BinaryNumber -> BinaryNumber -> BinaryNumber
(BinaryNumber a) |+| (BinaryNumber b) = BinaryNumber $ reverse digits
    where longest = max (length a) (length b)
          aPadded = pad longest a
          bPadded = pad longest b
          digits = addReversedDigits Zero $ reverse  (zip aPadded bPadded)
    