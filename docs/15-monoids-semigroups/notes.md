# Monoids and Semigroups

## Algebra

An **algebra** refers to some operations and the sets for which they operate
over. In Haskell, algebras are encoded via *typeclasses*.

## Monoid

A `#!hs Monoid` is a *binary associative* operation with an *identity*.

Let $S$ be an set and let $\bullet \colon S \times S \to S$, then $(S, \bullet)$ is
a `#!hs Monoid` iff it satisfies two axioms:

1. **Associativity**.
    $\forall a, b, c \in S \colon (a \bullet b) \bullet c \equiv a \bullet (b \bullet c)$

2. **Identity**.
    $\exists e \in S \colon \forall a \in S \colon e \bullet a \equiv a \bullet e \equiv a$

!!! note "Monoid and Semigroup"
    A **monoid** *is* a **semigroup** with an *identity* element.

In Haskell, a monoid is encoded by the `#!hs Monoid` typeclass.

```haskell
class Monoid m where
    mempty  :: m
    mappend :: m -> m -> m
    mconcat :: [m] -> m
    mconcat = foldr mappend mempty
```

Note that the binary operation $\bullet$ corresponds to the `#!hs mappend`
operation and identity element corresponds to `#!hs mempty`.

Using typeclasses allow us to abstract common patterns out.

`#!hs Monoid` defines the infix operator `#!hs <>` to alias `#!hs mappend`.

```haskell
(<>) :: Monoid m => m -> m -> m
```

### Lists

`#!hs List` is a `#!hs Monoid` instance.

```haskell
instance Monoid [a] where
    mempty = []
    mappend = (++)
```

Here appending an empty list `#!hs []` to any list `#!hs l` does not change 
`#!hs l`, meaning that the empty list `#!hs []` is the neutral element. The list 
concatenation operation `#!hs (++)` is a binary operation which is in fact
associative — `[1, 2] ++ ([3, 4] ++ [5, 6]) == ([1, 2] ++ [3, 4]) ++ [5, 6]`.

### Integers

`#!hs Integer`s do *not* have `#!hs Monoid` instance (also for any other
numerical types), because both multiplication and addition have neutral
elements and are associative — but having two operations mean that it is not
clear whether to use multiplication or addition, yet each type should only
have one *unique* typeclass instance.

The ambiguity is resolved by having wrapper types `#!hs Sum` and `#!hs Product`
to wrap numerical values and consequently identify which `#!hs Monoid` instance
is desired.

### Monoid Laws

Any `#!hs Monoid` instance *must* abide by these identities, which are 
particularily useful for testing.

1. **Left identity**.

    ```haskell
    mappend mempty x = x
    -- with infix operator
    mempty <> x = x
    ```

2. **Right identity**.

    ```haskell
    mappend x mempty = x
    -- with infix operator
    x <> mempty = x
    ```

3. **Associativity**.

    ```haskell
    mappend x (mappend y z) = mappend (mappend x y) z
    -- with infix operator
    x <> (y <> z) = (x <> y) <> z

    mconcat = foldr mappend mempty
    -- with infix operator
    mconcat = foldr (<>) mempty
    ```

### Usage

Since many types may be more than one sensible `#!hs Monoid` instances,
`#!hs newtype`s may be used to differentiate between which particular instance
to use.

`#!hs Monoid`s should be thought as a way of condensing values (or reducing
values into a overall summary representation) for types that do not have
straightforward definitions for `#!hs Monoid`.

#### Bool

In the case of `#!hs Bool`s, there are two possible `#!hs Monoid` instances,
for conjunction $\land$ and disjunction $\lor$. Here `#!hs newtype` can be
used to construct `#!hs All` and `#!hs Any` as newtypes for `#!hs Bool`'s
`#!hs Monoid` instance.

```haskell
newtype All = All { getAll :: Bool }

newtype Any = Any { getAny :: Bool }
```

`#!hs All` represents the `#!hs Monoid` instance for **conjunction** ($\land$ 
and) operation, whereas `#!hs Any` represents the `#!hs Monoid` instance for
**disjunction** ($\lor$ or) operation.

```haskell
instance Monoid All where
    mempty = True
    mappend = (&&)

instance Monoid Any where
    mempty = False
    mappend = (||)
```

These definitions are quite intuitive. For conjunction, $a \land \top = a$,
whereas for disjunction $a \lor \bot = a$. Here, the results of the binary
operations only depend on which `#!hs Bool` value $a$ takes.

#### Maybe

`#!hs Maybe` has *many* possible `#!hs Monoid` instances.

##### First and Last

This particular instance is similar to boolean disjunction, but with respect to
the leftmost or rightmost success in a series of `#!hs Maybe`s.

In the case of `#!hs Maybe`s, a decision must be made if there are multiple
successes.

!!! example "First"
    ```haskell
    First (Just 1) <> First (Nothing) <> First (Just 3)
    -- => 
    First { getFirst = Just 1 }

    First (Nothing) <> First (Just 2)
    -- =>
    First { getFirst = Just 2 }
    ```

!!! example "Last"
    ```haskell
    Last (Just 1) <> Last (Nothing) <> Last (Just 3)
    -- => 
    Last { getLast = Just 3 }

    Last (Just 1) <> Last (Nothing) <> Last (Nothing)
    -- =>
    Last { getLast = Just 1 }
    ```

##### Reusing Algebras

```haskell
instance Monoid b => Monoid (a -> b)

instance (Monoid a, Monoid b)
    => Monoid (a, b)

instance (Monoid a, Monoid b, Monoid c)
    => Monoid (a, b, c)
```

## Semigroup

A `#!hs Semigroup` is a `#!hs Monoid` without the identity. That is, we can
also define `#!hs Monoid` to be a further constrained `#!hs Semigroup`.

```haskell
class Semigroup m => Monoid m where
    mempty :: m -- Identity element
```

With the `#!hs mappend` coming from the `#!hs Semigroup` constraint.

Given some set $S$ and a binary associative operation 
$\bullet \colon S \times S \to S$, then $(S, \bullet)$ is a `#!hs Semigroup` iff it 
satisfies the associativity axiom:

1. **Associativity**.
    $\forall a, b, c \in S \colon (a \bullet b) \bullet c \equiv a \bullet (b \bullet c)$

```haskell
class Semigroup m where
    mappend :: m -> m -> m
```

Note that `#!hs (<>) :: Semigroup m => m -> m -> m` in the case of 
`#!hs Semigroup`.

!!! note "Semigroup as superclass of Monoid"
    ```haskell
    class Semigroup m => Monoid m where
        mempty :: m
    ```

### Semigroup Laws

The removal of the identity requirement means that only the associativity 
identity is left.

1. **Associativity**.

    ```haskell
    mappend x (mappend y z) = mappend (mappend x y) z
    -- with infix operator
    x <> (y <> z) = (x <> y) <> z
    ```

### NonEmpty

A useful datatype which is an instance of `#!hs Semigroup` is the `#!hs NonEmpty`
data type which represents a non-empty list.

```haskell
data NonEmpty a = a :| [a]
    deriving (Eq, Ord, Show)
```

The infix data constructor `#!hs :|` takes two arguments, an element `#!hs a`
and a list `#!hs [a]` which may or may not be empty. This guarantees that the
data type is always exhibited with at least one element of type `#!hs a`.
