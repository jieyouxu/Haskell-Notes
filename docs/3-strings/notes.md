# Strings

## Types

**Types** are ways to *categorize* values.

!!! example "Finding type information using GHCi"
    ```haskell
    Prelude> :type 'a'
    'a' :: Char
    ```

    For Strings, such as `#!hs "Hello World"`,

    ```haskell
    Prelude> :type "Hello World"
    "Hello World" :: [Char]
    ```

    Here `#!hs String` is a *type alias* for `#!hs [Char]`, a list of 
    characters.

## Printing Strings

Functions such as `#!hs print` may be used to print `#!hs String`s and other 
data types to the console.

`#!hs putStr` and `#!hs putStrLn` are specialized for `#!hs String` data type.

### IO Type

The `#!hs IO` type standards for Input/Output, and represents effects which
are not pure.

!!! note "Do syntax"
    The `#!hs do` syntax sequences actions:

    ```haskell
    main :: IO ()
    main = do
        putStrLn "1. action 1"
        putStrLn "2. action 2"
        putStrLn "3. action 3"
    ```

## Concatenating Strings

The concatenation operator `#!hs (++)` may be used to concat two strings (or 
lists of `#!hs Char`s together).

It has the type signature

```haskell
(++) :: [a] -> [a] -> [a]
```

That is, it takes two lists of some arbitary type `#!hs a` and combines them
to give a single combined list of `#!hs a`s.

Such arbitary type is a *wildcard* type, which can be any type. Since it is the
same type variable `#!hs a` throughout, the input lists and output list must
have elements of the same type `#!hs a`.

!!! example "String concatenation operator"
    ```haskell
    Prelude> "Hello " ++ "World!"
    Hello World!
    ```

The `#!hs concat` function can also be used to combine some `#!hs Foldable` list
with elements of arbitary type `#!hs a`.

```haskell
concat :: Foldable t => t [a] -> [a]
```

!!! example "String concat"
    ```haskell
    Prelude> concat ["Hello", " ", "World!"]
    Hello World!
    ```

## Lists

### Prepend

The cons operator `#!hs (:)` prepends an element to a list (of the same type).

```haskell
(:) :: a -> [a] -> [a]
```

### Getting first element

The `#!hs head` function returns the first element of a list.

```haskell
head :: [a] -> a
```

!!! note "What if the list is empty?"
    Haskell will through an exception should the list be empty.

    It may be wise to wrap the `#!hs head` function into a `#!hs safeHead`
    function where
    
    ```haskell
    safeHead :: [a] -> Maybe a
    safeHead [] = Nothing
    safeHead (x:xs) = Just x
    ```

### Getting every element except for the first

The `#!hs tail` function returns all elements but the first element of a list.

```haskell
tail :: [a] -> [a]
```

!!! note "Empty list"
    Similar to head, Haskell will also throw exception if list is empty.

    A safe version `#!hs safeTail` can also be used where

    ```haskell
    safeTail :: [a] -> Maybe [a]
    safeTail [] = Nothing
    safeTail (x:xs) = Just xs
    ```

### Getting some specified number of elements

The `#!hs take` function returns a selected number of elements, counting from
the left.

```haskell
take :: Int -> [a] -> [a]
```

### Keeping a specified number of elements

The `#!hs drop` function discards a selected number of elements, counting from
the left, and returns the remainder.

```haskell
drop :: Int -> [a] -> a
```

### Indexing

The `#!hs (!!)` infix indexing operator returns the element in the specified
position with the index starting from 0.

```haskell
(!!) :: [a] -> Int -> a
```
