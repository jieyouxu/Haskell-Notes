# Functors

The `#!hs Functor` typeclass is about abstracting mapping over structures.

??? example "Negation"
    Logical *negation* ($\neg$) can be considered a `#!hs Functor` since when
    $\neg$ is applied to some input sentence $A$, it outputs $\neg A$; the
    concept of negation is *lifted* over the entire sentence and does not change
    the internal structure — here, the terms within the sentence $A$ remains
    unchanged and the negation operator is applied to the entire sentence.

## Basics

A `#!hs Functor` is an abstraction for applying a function to values within
some structure without altering the structure itself.

```haskell
class Functor f where
    fmap :: (a -> b) -> f a -> f b
```

`#!hs fmap` is aliased with the infix operator `#!hs <$>`.

```haskell
<$> :: Functor f => (a -> b) -> f a -> f b
```

??? note "Explicit kind signatures"
    It is possible to give explicit type signatures, for example:

    ```haskell
    class Functor (f :: * -> *) where
        fmap :: (a -> b) -> f a -> f b
    ```

## Identities

1. **Identity**

    ```haskell
    fmap id == id
    ```

2. **Composition**

    ```haskell
    fmap (f. g) == fmap f . fmap g
    ```

## Structure Preservation

The two identities guarantee that `#!hs Functor`s shall be structure-preserving.

In the sigature of `#!hs fmap :: Functor f => (a -> b) -> f a -> f b`, since the
input structure `#!hs f` is identical to the output structure `#!hs f`, then it
can be deduced that `#!hs fmap` does not alter the underlying structure.

## Uniqueness to Datatype

`#!hs Functor` instances will be unique for its datatype because of the
parametricity in the type arguments, requiring the structure `#!hs f` in\
`#!hs Functor f` to have precisely the kind `#!hs f :: * -> *`.
