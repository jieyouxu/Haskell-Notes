# Alternative

The `#!hs Alternative` typeclass is useful to express the combination of results
from multiple computations.

```haskell
class Applicative f => Alternative f where
    {-# MINIMAL empty | (<|>) #-}

    empty :: f a
    (<|>) :: f a -> f a -> f a
```

Here `#!hs empty` represents some computation which yields zero results, while
the `#!hs (<|>)` operator represents either a choice or parallel execution.

!!! example "`#!hs Alternative` Instance for `#!hs Maybe`"
    ```haskell
    instance Alternative Maybe where
        empty = Nothing
        Nothing <|> r = r
        l       <|> _ = l
    ```

!!! example "`#!hs Alternative` Instance for `#!hs []`"
    ```haskell
    instance Alternative [] where
        empty = []
        (<|>) = (++)
    ```

## Laws

1. Neutral element `#!hs empty`.

    ```haskell
    -- empty is a neutral element
    empty <|> u = u
    u <|> empty = u
    ```

2. Associative `#!hs (<|>)`.

    ```haskell
    u <|> (v <|> w) = (u <|> v) <|> w
    ```
