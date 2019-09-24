# Foldable

The `#!hs Foldable` typeclass describes a class of datatypes which can be
folded into a *summary value*.

```haskell
-- A MINIMAL annotaion requires that any Foldable typeclass instance must at
-- lease specify either foldMap or foldr.
class Foldable t where
    {-# MINIMAL foldMap | foldr #-}
    fold    :: Monoid m => t m -> m
    foldMap :: Monoid m => (a -> m) -> t a -> m
```

Here `#!hs fold` allows values of type `#!hs m` within some structure `#!hs t`
to be combined via their `#!hs Monoid` instances.

The `#!hs foldMap` operation first maps elements of type `#!hs a` to some
type `#!hs m` which is an instance of `#!hs Monoid` in order to get the
value-combining capability, and then combines the values into a summary value
via the `#!hs Monoid` instance.

??? note "With explicit kind signatures"
    ```haskell
    class Foldable (t :: * -> *) where
        {-# MINIMAL foldMap | foldr #-}
    ```

??? example "`#!hs fold`"
    ```haskell
    fold (+) $ map Sum [1..5]
    ```

    Notice the `#!hs map Sum` required to lift `[1..5]` into their `#!hs Sum`
    `#!hs Monoid` instances.

??? example "`#!hs foldMap`"
    ```haskell
    foldMap Product [1..5]
    ```

    Here the function argument of `#!hs foldMap` is required to map each elment
    of `#!hs [1..5]` into some `#!hs Monoid` instance, in this case 
    `#!hs Product`.

## Derived Operations

### To List

```haskell
toList :: Foldable t => t a -> [a]
```

### Length

```haskell
length :: Foldable t => t a -> Int
```

### Element Of

```haskell
elem :: (Eq a, Foldable t) => a -> t a -> Bool
```

### Largest and Least Element

```haskell
maximum :: Ord a => t a -> a
minimum :: Ord a => t a -> a
```

### Sum and Product

```haskell
sum :: (Foldable t, Num a) => t a -> a
product :: (Foldable t, Num a) => t a -> a
```

## Null

Is the `#!hs Foldable` structure empty?

```haskell
null :: Foldable t => t a -> Bool
```
