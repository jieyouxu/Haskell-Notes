# Reader

Sometimes "globals" or environmental configurations need to be passed around
the entire application. But such information should not be passed via arguments
since it will clutter the types of every function. The `#!hs Reader` datatype
can be used to handle this burden.

!!! note "`#!hs Functor`ial Context"
    Normally, function composition is done with the composition operator 
    `#!hs (.)`.

    ```haskell
    fn_a :: Integer -> Integer
    fn_a = (* 2)

    fn_b :: Integer -> Integer
    fn_b = (+ 4)

    fn_c :: Integer -> Integer
    fn_c = fn_a . fn_b
    ```

    Upon applying `#!hs fn_c` to some input, `#!hs fn_b` will be applied to the
    input first, whose result will be passed on to `#!hs fn_a`.

    Function composition can also be achieved via `#!hs fmap`. Here, the 
    structure or context for `#!hs fn_c` is a **partially applied function**.

!!! note "`#!hs Functor` Instance for Function"
    The `#!hs Functor` instance for a partially applied function (from a
    function of type `#!hs a -> r`, or `#!hs (->) a r`) is:

    ```haskell
    instance Functor ((->) a) where
        -- fmap :: (b -> c) -> ((->) a) b -> ((->) a) c
        -- fmap f g = \x -> f (g x)
        fmap = (.)
    ```

!!! note "`#!hs Applicative` Context"
    ```haskell
    fn_d :: Integer -> Integer
    fn_d = (+) <$> fn_a <*> fn_b

    -- or equivalently
    fn_d' :: Integer -> Integer
    fn_d' = liftA2 (+) fn_a fn_b
    ```

    In this case the argument will get passed to `#!hs fn_a` and `#!hs fn_b`
    simultaneously and their results will be added together.

!!! note "`#!hs Applicative` Instance for Function"
    ```haskell
    instance Applicative ((->) r) where
        -- (<*>) :: ((->) r) (a -> b) -> ((->) r) a -> ((->) r) b
        -- f :: r -> a -> b
        -- g :: r -> a
        pure x  = \_ -> x
        f <*> g = \x -> f x (g x)
    ```

!!! note "`#!hs Monad` Instance for Function"
    ```haskell
    instance Applicative ((->) r) => Monad ((->) r) where
        -- return :: a -> r -> a
        return :: a -> ((->) r) a
        return = const

        -- (>>=) :: (r -> a) -> (a -> r -> b) -> (r -> b)
        (>>=) :: ((->) r) a -> (a -> ((->) r) b) -> ((->) r) b
        -- x :: r
        -- f :: r -> a
        -- g :: a -> r -> b
        -- f >>= g = \x -> g (f x) x
        f >>= g = flip g <*> f
    ```

!!! note "`#!hs Reader`"
    Partially applied functions have `#!hs Functor`, `#!hs Applicative` as well 
    as `#!hs Monad` instance.

    - `#!hs Functor` for functions is *composition*.
    - `#!hs Applicative` and `#!hs Monad` instance pass argument forward in addition
    to the composition. 
        - Notice the input argument `#!hs r` is present in the created result function 
        `#!hs (r -> b)`.
        - Recall that `#!hs Applicative` and `#!hs Monad` are subclasses of 
        `#!hs Functor`.

    The `#!hs Reader` newtype is an abstraction for composing together functions 
    which are waiting for shared environmental inputs – it is an abstraction of
    function application and allows computation to be done in terms of some
    not-yet-supplied argument. `#!hs Reader` can help us avoid passing some
    environmental information explicitly.

```haskell
newtype Reader r a = Reader { runReader :: r -> a }
```

`#!hs r` is the input type and `#!hs a` is the result type of the function. The
newtype defines a convenient accessor function `#!hs runReader` which allows
the function to be retrieved from the newtype. `#!hs Reader r` is similar to
`#!hs ((->) r)`.

```haskell
instance Functor (Reader r) where
    fmap :: (a -> b) -> Reader r a -> Reader r b
    -- fmap f (Reader ra) = Reader $ \r -> f (ra r)
    fmap f (Reader ra) = Reader $ (f . ra)
```

Notice the similarity between `#!hs \r -> f (ra r)` and composition 
`#!hs \x -> f (g x)`. Thus we can use `#!hs (.)` to simplify.

## Read-only Type Argument

The `#!hs r` type argument being read-only imposes the restriction that `#!hs r`
can only be swapped for your callees but not for your callers.

```haskell
-- swap Reader context
withReaderT :: (r' -> r) -> ReaderT r m a -> ReaderT r' m a
withReaderT f m = ReaderT $ runReaderT m . f
```
