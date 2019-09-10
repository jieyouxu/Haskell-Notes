# Lists

Haskell `#!hs List`s serve to:

1. Represent a *collection* of values.
2. Represent an *infinite series* of values (a *stream* of values).

## List Datatype

```haskell
data [] a = [] | a : [a]
```

Here `#!hs []` is the empty list, and `#!hs (:)` is the cons operator which
attaches some element `#!hs a` into the front of a list `#!hs [a]`.

## Pattern Matching

Matching head of list:

```haskell
head' :: [a] -> Maybe a
head' [] = Nothing
head' (x : _) = Just x
-- head element x is matched with rest of list discarded
```

Matching tail of list:

```haskell
tail' :: [a] -> Maybe [a]
tail' [] = Nothing
tail' (_ : []) = Nothing
tail' (_ : xs) = Just xs
```

## Syntatic Sugar

A list literal is used as

```haskell
aList = [1, 2, 3, 4] ++ [5]
```

Which is syntactic sugar for

```haskell
(1 : 2 : 3 : 4 : []) ++ (5 : [])
```

- *Cons cells* are List's second data constructor `#!hs a : [a]`.
- *Spine* nests cons cells.

## Ranges

```haskell
[1 .. 10] == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
[2, 4 .. 10] == [2, 4, 6, 8, 10]
['a' .. 'c'] = ['a', 'b', 'c']
```

Such range operator (with optional step) are syntatic sugar for instances of
`#!hs Enum` typeclass, namely for:

- `#!hs enumFrom :: Enum a => a -> [a]` (step omitted).
- `#!hs enumFromThen :: Enum a => a -> a -> [a]` (step included).
- `#!hs enumFromTo :: Enum a => a -> a -> [a]` (step included).
- `#!hs enumFromThenTo :: Enum a => a -> a -> -> a -> [a]` (step included).

## List Operations

### Take

```haskell
take :: Int -> [a] -> [a]
```

`#!hs take` keeps the first $n$ elements of a list, as specified with the 
`#!hs Int` argument, and discards the rest of the list.

### Drop

```haskell
drop :: Int -> [a] -> [a]
```

`#!hs drop` drops the first $n$ elements of a list, as specified with the
`#!hs Int` argument, and keeps the rest of the list.


### Split At

```haskell
splitAt :: Int -> [a] -> ([a], [a])
```

`#!hs splitAt` partitions a list into two portions at the supplied position
provided by the `#!hs Int` argument.

### Take While

```haskell
takeWhile :: (a -> Bool) -> [a] -> [a]
```

`#!hs takeWhile` keeps the elements of the input list until it encounters an
item which fails to satisfy the predicate `#!hs (a -> Bool)`.

### Drop While

```haskell
dropWhile :: (a -> Bool) -> [a] -> [a]
```

`#!hs dropWhile` discards elements of the input list until it encounters an
item which fails to satisfy the predicate `#!hs (a -> Bool)`.

## List Comprehension

A **list comprehension** generates a new list from a list or lists. A
*generator* list is required to provide input, with optional conditions to
select which elements are included and/or how to map elements from input list
to the generated list.

!!! example "Simple list comprehension"
    ```haskell
    squared = [ x^2 | x <- [1..10] ]
    == [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
    ```

    - `#!hs x^2` is the output function which is applied to each element of
    the input list to generate each element of the output list.
    - The pipe `#!hs |` separates output function and input.
    - `#!hs [1..10]` is the input list:
      - From a list of `#!hs 1` to `#!hs 10`,
      - Take (as designated by operator `#!hs <-`) each element and bind it to
      the name `#!hs x`.

!!! example "List comprehension with predicate"
    ```haskell
    evenSquared = [ x^2 | x <- [1..10], x `mod` 2 == 0 ]
    == [4, 16, 36, 64, 100]
    ```

    An additional predicate is added here `#!hs x `mod` 2 == 0` which checks
    if each supplied input bound to `#!hs x` is an even number; if the condition
    succeeds, the input is kept and otherwise filtered off.

!!! example "List comprehension from multiple input list"
    ```haskell
    [x ^ y | x <- [1..5], y <- [2..3] ]
    == [1, 1, 4, 8, 9, 27, 16, 64, 25, 125]
    ```

    Notice that the rightmost generator `#!hs y <- [2..3]` is exhausted first,
    then the second rightmost, etc.

## Spines and Non-strict Evaluation

Haskell's List definition is recursive by nature.

A **spine** is the connective structure which ties the collection of values
together.

```haskell
1 : 2 : 3 : [] == [1, 2, 3]

  :
 / \
1   :
   / \
  2   :
     / \
    3   []
```

Evaluation of the list proceeds *down* the spine but construction proceeds
*up* the spine.

!!! note "sprint"
    GHCi has the `#!hs :sprint` which can be used to print variables to see
    what has already been evaluated; underscores represent values not yet
    evaluated.

    Sometimes GHC introduce preemptive strictness for optimization purposes,
    and polymorphism for cases such as `#!hs Num a => a` may need the argument
    in order for it to be concrete; it may show up as underscore unless a more
    concrete type is supplied.

!!! example "Sprint and List"
    Upon definition, the list is not evaluated as it is not necessary.

    ```haskell
    Prelude> let blah = enumFrontTo 'a' 'z'
    Prelude> :sprint blah
    blah = _
    ```

    Upon taking one element, the list is evaluated from its topmost spine and
    the outmost cons cell is evaluated.

    ```haskell
    Prelude> take 1 blah
    "a"
    Prelude> :sprint blah
    blah = 'a' : _
    ```

    Upon taking the second element, the second cons cell is evaluated which
    yields the second value.

    ```haskell
    Prelude> take 2 blah
    "ab"
    Prelude> :sprint blah
    blah = 'a' : 'b' : _
    ```    

!!! note "Length"
    When `#!hs length` is applied to a list, only the spine part is evaluated
    but not the elements (not the contained values). But `#!hs sprint` shows
    the list as if all cons cells are evaluated which is not the case.

!!! note "Spines evaluated independently from values"
    Haskell values are reduced to **Weak Head Normal Form** (WHNF) by default.
    It means that expressions are only reduced as far as necessary to reach a
    data constructor.

    WHNF is a superset of NF (normal form) in that WHNF can contain both
    partially reduced expressions (to a data constructor or lambda) and fully
    reduced expressions (i.e. normal form).

!!! note "Length is strict on spine"
    Given some list such as `#!hs [1, 2, 3]` and if `#!hs length` is applied to
    it, then the full spine will be evaluated but not the values contained
    within the cons cells:

    ```haskell
      :
     / \
    _   :
       / \
      _   :
         / \
        _   []
    ```

    If the list contained a bottom value, i.e. `#!hs undefined`, applying
    `#!hs length` to the list will not cause a crash precisely because the
    values are not evaluated.

## List Transformation

### Map

`#!hs map` can be used to uniformly apply some function to each member of a 
list (which creates a new list).

`#!hs fmap` is a more generic version of `#!hs map` which works for all
instances of `#!hs Functor` (for which list is an instance of).

```haskell
map :: (a -> b) -> [a] -> [b]
fmap :: Functor f => (a -> b) -> f a -> f b
```

Notice that `#!hs map` is a higher-order function which takes a transformation
function of type `#!hs a -> b`, which transform an element from the input
list of type `#!hs a` into an element of the output list of type `#!hs b`. Of
course, `#!hs a` and `#!hs b` do not necessarily have to be of distinct types.

`#!hs map` is defined as

```haskell
map :: (a -> b) -> [a] -> [b]
map _ [] = []
map f (x : xs) = f x : map f xs
```

Here `#!hs map` simply returns an empty list if the input list is empty.

Otherwise, `#!hs map` destructures the input list into its head element `#!hs x`
and the rest as the list `#!hs xs`. It applies the transformation function
`#!hs f` to the head element `#!hs x`, then cons the result `#!hs f x` to the
result of recursively applying `#!hs map` to the remaining items.

### Filter

`#!hs filter` takes an input list and a predicate, and returns a new list
consisting of elements from the input list which passes the predicate check.

??? example "Simple filter example"
    ```haskell
    Prelude> filter even [1..10]
    [2, 4, 6, 8, 10]
    ```

```haskell
filter :: (a -> Bool) -> [a] -> [a]
filter _ [] = []
filter predicate (x : xs)
    | predicate x = x : filter predicate xs
    | otherwise   = filter predicate xs
```

As from the definition, `#!hs filter` builds a new list from the input list
and omits elements from the input list which do not pass the `#!hs predicate`
check.

### Zipping

Lists can be zipped together to form a single list.

```haskell
zip :: [a] -> [b] -> [(a, b)]
```

Which simply takes two input lists, and builds a new list by combining pairs
of elements from `#!hs [a]` and `#!hs [b]`.

!!! example "Zipping list"
    ```haskell
    Prelude> zip [1, 2, 3] [4, 5, 6]
    [(1, 4), (2, 5), (3, 6)]
    ```

!!! note "Zip stops when it runs of out of elements"
    If either of the input list has less elements, `#!hs zip` will only combine
    up to the shorter of the two.

    ```haskell
    Prelude> zip [1, 2] [4, 5, 6]
    [(1, 4), (2, 5)]
    ```

`#!hs unzip` can be used to recover the original lists (or up to the length
of the shorter of the original lists).

```haskell
unzip :: [(a, b)] -> ([a], [b])
```

`#!hs zipWith` can be used to apply a combining function:

```haskell
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
```

The combining function takes an element from either input lists, `#!hs a` and
`#!hs b`, and returns a combined value of type `#!hs c`.
