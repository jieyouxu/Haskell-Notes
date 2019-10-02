# MonadPlus

The `#!hs MonadPlus` typeclass is similar to `#!hs Alternative` with different
typeclass constraints and some additional laws.

```haskell
class Monad m => MonadPlus m where
    mzero :: m a
    mplus :: m a -> m a -> m a
```

Which, apart from the `#!hs Monad` constraint, looks identical to
`#!hs Alternative`. The `#!hs Monad` constraint and requirements for having
left and right zeros make `#!hs MonadPlus` strong than `#!hs Alternative`.

## Laws

!!! warning "Disagreements"
    Note that the precise set of laws that `#!hs MonadPlus` should satisfy for
    is not agreed upon!

    - `#!hs []` satisfies `#!hs Monoid` laws, left zero and left distribution.
    - `#!hs Maybe`, `#!hs IO` and `#!hs STM` satisfy `#!hs Monoid` laws, left
      zero and left catch.

1. Neutral element `#!hs mzero`.

    ```haskell
    mplus mzero a = a
    mplus a mzero = a
    ```

2. Associative binary operation `#!hs mplus`.

    ```haskell
    mplus (mplus a b) c = mplus a (mplus b c)
    ```

3. Left zero.

    ```haskell
    mzero >>= k = mzero
    ```

4. Left distribution.

    ```haskell
    mplus a b >>= k = mplus (a >>= k) (b >>= k)
    ```

5. Left catch.

    ```haskell
    mplus (return a) b = return a
    ```
