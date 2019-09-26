# State

We often need state — it can be considered data which serves as additional
context in addition to inputs and outputs of functions, which may change after
each function's evaluation.

## State Newtype

In Haskell, the `#!hs State` newtype is used to express state which may change 
in evaluation that does not require mutation (and avoid implicit contexts).

The `#!hs State` `#!hs Monad` instance grants us access to state that:

1. Avoids `#!hs IO`.
2. Has data that is self-contained.
3. Maintains referential transparency.
4. Explicit in type signatures.

It is most suitable when the programmer needs to keep track of values which 
change with each evaluation step that may be read or written but *without
mutation*.

```haskell
newtype State s a = State { runState :: s -> (a, s) }
```

!!! "Isomorphism in `#!hs newtype` Declarations"
    Since `#!hs newtype`s are to be erased at runtime as to not cause additional
    runtime costs to incur, any functions contained within `#!hs newtype`
    declarations must be **isomorphic** to the type that is being wrapped.
    A wrapper type `#!hs w a` is said to be **isomorphic** to its wrapped type
    `#!hs a` if and only if they can be converted between each other without
    losing information.

    ```haskell
    type Isomorphism a b = (a -> b, b -> a)
    ```

In the case of the `#!hs State` newtype, where its sole data constructor
`#!hs State` and record accessor `#!hs runState` has the types:

```haskell
State :: (s -> (a, s)) -> State s a

runState :: State s a -> s -> (a, s)
```

Notice that the data constructor `#!hs State` takes an input state and returns 
the output value `#!hs a` in addition to a new state. It is important that the
state value with each application is chained and passed on to the next 
application.

!!! note "`#!hs State` `#!hs Functor` Instance"
    ```haskell
    instance Functor (State s) where
        fmap f (State g) = State $ \oldState ->
            let (  val, newState) = g oldState
            in  (f val, newState)
    ```

!!! note "`#!hs State` `#!hs Applicative` Instance"
    ```haskell
    instance Applicative (State s) where
        pure a = State $ \s -> (a, s)

        (State f) <*> (State g) = State $ \s0 ->
            let (fn,    s1) = f s0
                (value, s2) = g s1
            in  (fn value, s2)
    ```

!!! note "`#!hs State` `#!hs Monad` Instance"
    ```haskell
    instance Monad (State s) where
        return = pure
        
        (State f) >>= g = State $ \s0 ->
            let (a, s1)   = f s0
                (State h) = g a
            in  h s1
    ```
