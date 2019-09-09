# Functional Patterns

## Anonymous Functions

!!! example "Anonymous function syntax"
    ```haskell
    addOne :: Integer -> Integer
    addOne x = x + 1
    ```

    Is identical to

    ```haskell
    (\x -> x + 1) :: Integer -> Integer
    ```

Anonymous functions are useful especially when used as arguments passed to
higher order functions.

!!! example "Anonymous function as argument"
    ```haskell
    addOneToAll :: Integer -> [Integer] -> [Integer]
    addOneToAll value xs = map (\x -> x + value) xs 
    ```

## Pattern Matching

Patterns are matched against values or data constructors and not types.
Pattern matching allows destructing arguments to check for desired patterns;
should the desired pattern exist, the value will be matched and bound to named
variables.

!!! example "Pattern matching numbers"
    ```haskell
    isZero :: Integer -> Bool
    isZero 0 = True
    isZero _ = False
    ```

!!! note "Order of definition affects pattern matching"
    Wildcard pattern `#!hs _` should always be the last case, otherwise it will
    unconditionally catch every possible input.

    ```haskell
    isZero :: Integer -> Bool
    isZero _ = False
    isZero 0 = True
    ```

    Will always give `#!hs False` even if the input is `#!hs 0`. That last
    case `#!hs isZero 0 = True` will *never* be reached.

    GHCi will provide warning for such overlapped patterns; but the programmer
    shall take care to order the cases from the most specific to the most
    generic.

!!! note "Bottom will be returned if pattern matching is non-exhaustive"
    If not all cases are handled for all possible input values, the *bottom* 
    value (which expresses a non-value) will be returned and an expcetion will
    be thrown.

!!! example "Pattern matching against data constructors"
    ```haskell
    module User where

    newtype UserId = UserId Integer
    
    newtype UserName = UserName String

    data User =
        UnregisteredUser
      | RegisteredUser UserId UserName
    ```

    Since `#!hs User` has two data constructors, we can pattern matching against
    both.

    ```haskell
    showInfo :: User -> String
    showInfo (UnregisteredUser) = "Unregistered"
    showInfo (RegisteredUser id name) =
        "Registerd user: { " ++ (show id) ++ name ++ "}"
    ```

!!! note "Newtype"
    The `#!hs newtype` keyword allows declaring a datatype with only one
    data constructor; it is more efficient than the `#!hs data` declaration
    but is more restrictive.

!!! example "Pattern matching tuples"
    ```haskell
    f :: (Integer, Bool) -> Bool
    f (i, b) =  if (i > 0 && b) 
                then True
                else False
    ```

## Case Expressions

!!! example "Case expression matching on Bool"
    ```haskell
    pluralize :: Integer -> String
    pluralize i =
        case i > 1 of
            True -> "s"
            False -> ""
    ```

!!! example "Palindrome check"
    ```haskell
    isPalindrome :: String -> String
    isPalindrome xs =
        case xs == reverse xs of
            True -> "Yes"
            False -> "No"
    ```

## Guards

!!! example "Absolute value"
    ```haskell
    abs' :: Integer -> Integer
    abs' n
        | n < 0     = (-n)
        | otherwise = n
    ```

Like pattern matching, the order of the branches also matters, with matching
occuring top-to-down.

!!! example "Right triangle"
    ```haskell
    isRightTriangle :: (Num a, Eq a) => a -> a -> a -> Bool
    isRightTriangle a b c
        | a^2 + b^2 == c^2  = True
        | otherwise         = False
    ```

## Function Composition

The composition function `#!hs (.)` has the signature

```haskell
(.) :: (b -> c) -> (a -> b) -> a -> c
```

It takes two functions and an argument:

1. It takes a function `#!hs f :: b -> c`.
2. It takes a function `#!hs g :: a -> b`.
3. It takes an argument `#!hs x :: a`.

The composition function applies `#!hs x` to the first function `#!hs g`,
and takes the output from `#!hs g` and feeds it to `#!hs f`.

With parentheses,

```haskell
(.) :: (b -> c) -> (a -> b) -> (a -> c)
```

The composition function takes two functions and creates a new function which
is the combination of the two input functions:

1. It takes a function `#!hs f :: b -> c`.
2. It takes a function `#!hs g :: a -> b`.
3. It creates and returns a new function `#!hs h :: a -> c`.

That is,

```haskell
(f . g) x == f (g x)
```

Note that the composition function `#!hs (.)` is right associative.

As such,

```haskell
(f . g . h) x == f (g (h x))
```

## Point-free Style

Point-free style refers to composing functions without specifying their
parameters – this helps to place emphasize on the functions.

```haskell
(f . g . h) x == f (g (h x))
-- equivalent to
f . g . h == \x -> f (g (h x))
```

!!! example "Point-free function"
    ```haskell
    f :: Int -> [Int] -> Int
    f z xs = foldr (+) z xs
    -- equivalent to
    f' :: Int -> [Int] -> Int
    f' = foldr (+)
    ```

!!! example "Point-free function"
    ```haskell
    countChar :: [Char] -> Integer
    countChar c = length . filter (== c)

    countAs :: [Char] -> Integer
    countAs = countChar 'a'
    ```
