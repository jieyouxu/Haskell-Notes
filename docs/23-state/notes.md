# State

We often need state — it can be considered data which serves as additional
context in addition to inputs and outputs of functions, which may change after
each function's evaluation.

## State Type

In Haskell, the `#!hs State` type is used to express state which may
change in evaluation that does not require mutation (and avoid implicit 
contexts).

The `#!hs State` `#!hs Monad` instance grants us access to state that:

1. Avoids `#!hs IO`.
2. Has data that is self-contained.
3. Maintains referential transparency.
4. Explicit in type signatures.

It is most suitable when the programmer needs to keep track of values which 
change with each evaluation step that may be read or written but *without
mutation*.
