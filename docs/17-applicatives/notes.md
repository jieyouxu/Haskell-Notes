# Applicatives

`#!hs Applicative`s are *monoidal functors* (i.e. the additive combination
of `#!hs Monoid`s and `#!hs Functor`s).

For `#!hs Applicative`s, the function and its target value both have structures
which are expected to be altered, and combined.

```haskell
class Functor f => Applicative f where
    pure    :: a -> f a
    (<*>)   :: f (a -> b) -> f a -> f b
```

It is hence implied that any type which is an instance of `#!hs Applicative`
is also consequently an instance of `#!hs Functor`.

The `#!hs pure` operation lifts some value `#!hs a` into a minimal structure
`#!hs f`, i.e. a into an structural identity.

!!! note "Similarity between `#!hs fmap` and `#!hs <*>`"

    ```haskell
    -- fmap
    <$> :: Functor f        =>   (a -> b)  -> f a -> f b
    -- apply
    <*> :: Applicative f    => f (a -> b)  -> f a -> f b
    ```

    Notice that `<*>`'s function `#!hs (a -> b)` is boxed within a functorial 
    structure `#!hs f`.

Some convenience functions are also provided in `#!hs Control.Applicative`.

```haskell
liftA  :: Applicative f => (a -> b) -> f a -> f b
liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
liftA3 :: Applicative f => (a -> b -> c -> d) -> f a -> f b -> f c -> f d
```

Notice that `#!hs liftA` is almost identical to `#!hs fmap` except that the
typeclass constraint on `#!hs f` is `#!hs Applicative` instead of `#!hs Functor`.

## Functors and Applicatives

A `#!hs Functor` can be defined in terms of an `#!hs Applicative` because
`#!hs Applicative` has all the operators of an `#!hs Functor` and more.

```haskell
fmap f x = pure f <*> x
-- or as prefix
fmap f x = (<*>) (pure f) x
```

## Applicative Functors and Monoidal Functors

```haskell
($)   ::   (a -> b) ->   a ->   b
(<$>) ::   (a -> b) -> f a -> f b 
(<*>) :: f (a -> b) -> f a -> f b 
```

Notice that from function application `#!hs ($)` to fmap `#!hs (<$>)` we wrapped
the input and output value with some structure `#!hs f` — this is the 
added functionality from `#!hs Functor` regarding structure preservance. From
fmap `#!hs (<$>)` we also wrap the mapping function in some structure bit,
having two piece of structure `#!hs f` in the argument to apply `#!hs <*>`.
To combine these two bits of structure `#!hs f` and end up with one single
bit of structure `#!hs f` in the output, we need the combining concept from
`#!hs Monoid`.

If the structure bit and function bit is split in the signature of apply 
`#!hs <*>`, it is easier to see the functionality provided by 
`#!hs Functor` and `#!hs Monoid` respectively.

```haskell
(<*>) :: f (a -> b) -> f a -> f b
-- functor
           (a -> b) ->   a ->   b
-- monoid
         f          -> f   -> f
```

We can then use `#!hs Monoid`'s `#!hs mappend` for combining the two input
structure bit, and normal function application `#!hs ($)` for the function and
value bit.

```haskell
mappend :: f          -> f   -> f
($)     ::   (a -> b) ->   a ->   b

(<*>)   :: f (a -> b) -> f a -> f b
```

## Applicative Laws

1. **Identity**

    ```haskell
    pure id <*> v = v
    ```

2. **Composition**

    ```haskell
    pure (.) <*> u <*> v <*> w = u <*> (v <*> w)
    ```

3. **Homomorphism** (structure-preserving map)

    ```haskell
    pure f <*> pure x = pure (f x)
    ```

4. **Interchange**

    ```haskell
    u <*> pure y = pure ($ y) <*> u
    ```
