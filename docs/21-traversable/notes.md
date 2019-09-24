# Traversable

The `#!hs Traversable` typeclass defined in `#!hs Data.Traversable` is given as

```haskell
class (Functor t, Foldable t) => Traversable t where
    {-# MINIMAL traverse | sequenceA #-}
    traverse :: Applicative f => (a -> f b) -> t a -> f (t b)
    traverse f = sequenceA . fmap f

    sequenceA :: Applicative f => t (f a) -> f (t a)
    sequenceA = traverse id
```

The `#!hs traverse` operation:

1. Maps elements of some structure to actions;
2. Evaluates such actions from left to right;
3. Collects the result.

## SequenceA

The `#!hs sequenceA` operation flips the two layers of structures/contexts and
does not allow any additional functions to be applied to values contained 
inside.

??? example "`sequenceA`"
    ```haskell
    fmap Just [1, 2 ,3]
    -- ==> [Just 1, Just 2, Just 3]

    sequenceA $ fmap Just [1, 2, 3]
    -- ==> Just [1, 2, 3]

    sequenceA [Just 1, Just 2, Just 3]
    -- ==> Just [1, 2, 3]
    ```

## Traverse

```haskell
traverse :: (Applicative f, Traversable t) => (a -> f b) -> t a -> f (t b)
```

Which is similar to `#!hs fmap` and `#!hs (=<<)` (flipped bind):

```haskell
fmap     :: Functor f                      => (a ->   b) -> f a -> f    b
(=<<)    :: Monad m                        => (a -> m b) -> m a -> m    b
traverse :: (Applicative f, Traversable t) => (a -> f b) -> t a -> f (t b) 
```

The same beneath-structure value-mapping still occurs like `#!hs fmap`, like
flipped bind, `#!hs traverse` also generates more structure. Notice that
different to `#!hs (=<<)`, `#!hs traverse` can have different structure type
in the result compared to the structure that was lifted for the function to
apply to, and eventually will flip the two structures `#!hs f` and `#!hs t`
around.

## MapM and Traverse, Sequence and SequenceA

There are legacy operations `#!hs mapM` and `#!hs sequence` which are defined
in GHC 7.10 and before which are less general versions of `#!hs traverse` and
`#!hs sequenceA` respectively.

```haskell
mapM     :: Monad m                        => (a -> m b) -> [] a -> m ([] b)
traverse :: (Applicative f, Traversable t) => (a -> f b) -> t  a -> f (t  b)
```

Notice that `#!hs traverse` is a generalization of `#!hs mapM` to other
`#!hs Traversable` structures not just limited to lists `#!hs []`, and also
loosening the typeclass constraint from `#!hs Monad` to only requring an
`#!hs Applicative`.

```haskell
sequence  :: Monad m                        => [] (m a) -> m ([] a)
sequenceA :: (Applicative f, Traversable t) => t  (f a) -> f (t  a)
```

Notice that `#!hs sequenceA` is a generalization of `#!hs sequence` in both
generalizing to `#!hs Traversable` structures not only restricted to lists 
`#!hs []`, but also loosening the typeclass constraint from `#!hs Monad` to
`#!hs Applicative`.

## Use Case

`#!hs Traversable` is useful for flipping two type constructors (optionally
also mapping in the process).

??? example "`#!hs Traversable`"
    It may be case that some function returns a list of `#!hs Maybe`s, i.e.
    `#!hs [Maybe a]`, but we may want `#!hs Maybe [a]` instead. Semantically,
    it may convey different meaning: a list of possible values is different from
    a possible list of values.

## Traversable Laws

### traverse

1. **Naturality**.

    ```haskell
    t . traverse f = traverse (t . f)
    ```

2. **Identity**.

    ```haskell
    traverse Identity = Identity
    ```

3. **Composition**.

    ```haskell
    traverse (Compose . fmap g . f) = Compose . fmap (traverse g) . traverse f
    ```

### sequenceA

The `#!hs sequenceA` must satisfy:

1. **Naturality**.

    ```haskell
    t . sequenceA = sequenceA . fmap t
    ```

2. **Identity**.

    ```haskell
    sequenceA . fmap Identity = Identity
    ```

3. **Composition**.

    ```haskell
    sequenceA . fmap Compose = Compose . fmap sequenceA . sequenceA
    ```
