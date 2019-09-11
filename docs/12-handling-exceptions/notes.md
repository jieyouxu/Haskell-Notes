# Handling Exceptions

!!! note "Exceptions"
    The *exceptions* here refers to exceptional cases such as invalid inputs,
    and not `Exception`s in languages like Java.

!!! note "Exceptions and control flow"
    `Exception`s in languages like Java have the problem of interfering with
    control flow and causes the `Exception` to propagate.

## Maybe

The usage of `#!hs Maybe` can be used to signal invalid input.

!!! example "Smart constructor"
    ```haskell
    -- aliases
    type Name = String
    type Age = Int

    data Person = Person Name Age deriving Show
    ```

    A smart constructor function `#!hs mkPerson :: Name -> Age -> Maybe Person`
    can be used to allow construction of a datatype only if the inputs satisfy
    certain constraints.

    ```haskell
    mkPerson :: Name -> Age -> Maybe Person
    mkPerson name age
        | name /= "" && age >= 0 = Just (Person name age)
        | otherwise              = Nothing
    ```

## Either

In addition to `#!hs Maybe`, where only a success / failure may be indicated,
the datatype `#!hs Either` may be used to attach causes of failure.

```haskell
data Either a b = Left a | Right b
```

!!! example "Indicating failure causes"
    ```haskell
    data PersonInvalid =
          EmptyName
        | NegativeAge
        deriving (Show, Eq)

    mkPerson :: Name -> Age -> Either PersonInvalid Person
    mkPerson name age
        | name /= "" && age >= 0 = Right (Person name age)
        | name == ""             = Left (EmptyName)
        | otherwise              = Left (NegativeAge)
    ```

    Notice that the datatype occupying the `#!hs Left` data constructor is
    the error cause, while the `#!hs Right` data constructor has the successful
    result.
