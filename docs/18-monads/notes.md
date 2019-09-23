# Monads

`#!hs Monad`s are *applicative functors* with additional features.

```haskell
class Applicative m => Monad m where
    (>>=)   :: m a -> (a -> m b) -> m b
    (>>)    :: m a -> m b -> m b
    return  :: a -> m a 
```

`#!hs return` does the same thing as `#!hs Applicative`'s `#!hs pure`, which
is to wrap a value into some structure `#!hs m` (which happens to be a
`#!hs Monad` instead of just `#!hs Applicative`).

The sequencing operator `#!hs (>>)` sequences two actions `#!hs m a` and
`#!hs m b` and discards any results from `#!hs m a`.

The bind operator `#!hs (>>=)` (often used via the `#!hs do` syntax) takes some
wrapped value `#!hs m a` and a mapping function `#!hs (a -> m b)` and feeds
the underlying value `#!hs a` from `#!hs m a` into the function, which in turn
yields `#!hs m b`.

But `#!hs Monad`s can cause structures to be wrapped inside structures. To
flatten such thick layers, the `#!hs join` operation is defined for 
`#!hs Monad`s which is able to flatten two `#!hs Monad` layers into one.

```haskell
join :: Monad m => m (m a) -> m a
```

??? note "`#!hs Applicative m`"
    Since `#!hs Monad` is stronger than `#!hs Applicative`, which is in turn
    stronger than `#!hs Functor`, both `#!hs Applicative` and `#!hs Functor`
    can be defined via `#!hs Monad` since they are both less powerful.

    ```haskell
    fmap f xs = xs >>= return . f
    ```

??? note "Misconcepts regarding `#!hs Monad`"
    - `#!hs Monad`s are *pure*.
    - `#!hs Monad`s are not imperative, since commutative `#!hs Monad`s do not
    need to order actions (useful property for concurrency!).
    - `#!hs Monad`s are not values.
    - `#!hs Monad`s are not about strict vs lazy.

## Lifting

`#!hs Monad`s also have corresponding `#!hs lift` functions, just like those
of `#!hs Applicative`s.

```haskell
liftM  :: Monad m => (a1 -> r) -> m a1 -> m r
liftM2 :: Monad m => (a1 -> a2 -> r) -> m a1 -> m a2 -> m r
```

## Monad and Do Syntax

```haskell
(*>) :: Applicative f => f a -> f b -> f b
(>>) :: Monad m       => m a -> m b -> m b
```

The operators `#!hs (*>)` and `#!hs (>>)` are both sequencing operators with
different typeclass constraint on the structure.

The `#!hs join` operation allows us to merge two effects into a single effect.

## Monad Laws

1. **Left Identity**.

    ```haskell
    return x >>= f = f x
    ```
2. **Right Identity**.

    ```haskell
    m >>= return = m
    ```

3. **Associativity**.

    ```haskell
    (m >>= f) >>= g = m >>= (\x -> f x >>= g)
    ```

## Kleisli Composition (à la Fish :fish:)

```haskell
(>=>) :: Monad m => (a -> m b) -> (b -> m c) -> a -> m c
```

Notice the similarity between the fish operator `#!hs (>=>)` and flipped
regular function composition operator `#!hs flip (.)`.

```haskell
flip (.) :: (a -> b) -> (b -> c) -> a -> c
```
