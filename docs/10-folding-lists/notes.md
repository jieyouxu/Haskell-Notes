# List Folding

## Folding

Folds are called **catamorphisms**, which are means of deconstructing data.

```haskell
foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b
```

When specialized to lists which are instances of `#!hs Foldable`:

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
```

A fold replaces the cons constructors with the supplied function
`#!hs (a -> b -> b)` and reduces the list.

## Recursion

In the case of `#!hs sum`, it uses `#!hs foldr` internally by replacing the
cons `#!hs (:)` constructors with the `#!hs (+)` operator.

Many functions such as `#!hs sum`, `#!hs length`, `#!hs concat`, `#!hs product`
when written in terms of themselves recursively have much structural similarity
where they relied on having an initial base case, then changing the cons
constructor into a different binary function.

??? example
    ```haskell
    sum :: [Integer] -> Integer
    sum [] = 0
    sum (x : xs) = x + sum xs

    length :: [a] -> Integer
    length [] = 0
    length (_ : xs) = 1 + length xs

    product :: [Integer] -> Integer
    product [] = 1
    product (x : xs) = x * product xs

    concat :: [[a]] -> [a]
    concat [] = []
    concat (x : xs) = x ++ concat xs
    ```

    Notice that each base case is the *identity* for the binary function, with
    associativity to the right — head is first evaluated, then the next head,
    and so on.

## Fold Right

`#!hs foldr` is right-associative.

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f id [] = id
foldr f id (x : xs) = f x (foldr f id xs )
```

!!! example
    ```haskell
    foldr (+) 0 [1, 2, 3]

    1 + (2 + (3 + 0))
    1 + (2 + 3)
    1 + 5
    6
    ```

Folding occurs in two stages:

1. **Traversal**: fold recursing the spine.
2. **Folding**: reduction of folding function applied to values.

All folds have same traversal direction, with the difference being in the
association of the folding function and thus the direction of reduction.

In the case of `#!hs foldr` and lazy evaluation, if `#!hs f` does not evaluate
rest of the fold no more part of the spine will be forced to evaluate. This
means that `#!hs foldr` can avoid evaluating not only the rest of the values,
but also rest of the spine. This allows `#!hs foldr` to be used with potentially
infinite lists.

## Fold Left

`#!hs foldl` traverses the input list's spine in the same direction as
`#!hs foldr`, but its folding process is left associative and thus proceeds
in the opposite direction as `#!hs foldr`.

```haskell
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f acc [] = acc
foldl f acc (x : xs) = foldl f (f acc x) xs
```

`#!hs foldl` begins its reduction process by applying the folding function to
the accumulator `#!hs acc` value and the head value.

!!! example
    ```haskell
    foldr (^) 2 [1..3]
    (1 ^ (2 ^ (3 ^ 2)))
    (1 ^ (2 ^ 9))
    (1 ^ 512)
    1
    ```

    ```haskell
    foldl (^) 2 [1..3]
    (((2 ^ 1) ^ 2) ^ 3)
    ((2 ^ 2) ^ 3)
    (4 ^ 3)
    64
    ```

!!! example
    ```haskell
    foldr (:) [] [1..3]
    [1, 2, 3]

    foldl (flip (:)) [] [1..3]
    [3, 2, 1]
    ```

!!! note "flip"
    The helper function `#!hs flip` can be used to change the argument order
    of a binary function:

    ```haskell
    flip :: (a -> b -> c) -> b -> a -> c
    flip f = \b -> (\a -> f a b)
    ```

    Or parenthesized:

    ```haskell
    flip :: (a -> b -> c) -> (b -> a -> c)
    ```

Note that `#!hs foldl` has unconditional recursion of the spine since the 
next recursion isn't determined by the folding function. This means that
it will not work for potentially infinite lists or lists which contain bottom
values.

## Folding and Evaluation

For finite lists, `#!hs foldr` and `#!hs foldl` is related by:

```haskell
foldr f z xs = foldl (flip f) z (reverse xs)
```
