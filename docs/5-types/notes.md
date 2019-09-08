# Types

- Haskell implements pure (typed) lambda calculus.
- Haskell improves on *System F* and *Hindley-Milner* type system for type
inference.
- Type systems enforce enstrictions to ensure correctness.
- Haskell is statically typed, meaning types are checked at compile time,
catching errors early.
- Types can also help optimizations.
- Types are good documentation.

## Type Polymorphism

Type variables such as `#!hs Num a => a` can be constrained. Here, type `#!hs a`
is required to be an instance of the `#!hs Num` typeclass. This is called
*constrained* polymorphism. Such `#!hs a` is called a typeclass-constrained
type variable.

## Function Type

The arrow operator `#!hs (->)` is the type constructor for functions.

```haskell
data (->) a b
```

## Typeclass Constraints

As previously mentioned, a polymorphic type variable may be constrained by
typeclass(-es).

```haskell
Num a => a
```

```haskell
(Num a, Num b) => a -> b -> b
```

## Currying

**Currying** allows the innermost body expression to have access to the value
of multiple arguments by nesting lambdas (even though each lambda only has
one argument).

Having some function such as

```haskell
fn :: a -> a -> a
```

When one argument is supplied to `#!hs fn`, a new function of type 
`#!hs a -> a` is returned with the previous argument filled in.

```haskell
fn :: a -> (a -> a)
```

Would be more accurate, but since `#!hs (->)` is right associative, the 
parentheses may be dropped.

Functions can also take other functions as argument (i.e. *higher-order 
functions*).

```haskell
map :: (a -> b) -> [a] -> [b]
```

Here the parentheses is necessary to group the `#!hs (a -> b)` part to 
designate it as a function as single argument and not two distinct arguments.

### Partial Application

If some function is curried, e.g. `#!hs map`, then part of the arguments can
be filled in.

For example, we can supply the identity function `#!hs id x = x` to `map`.

```haskell
id :: a -> a
id x = x

mapId :: [a] -> [b]
mapId xs = map id xs
```

Notice that:

- `#!hs map id`, `#!hs map` applied to `#!hs id`, has the type `#!hs [a] -> [b]`
which is *identical* to that of `#!hs mapId`.
- `#!hs mapId` does *nothing* to `#!hs xs` apart from passing it to 
`#!hs map id`. This means that `#!hs xs` can be omitted, and `#!hs mapId` can
simply be defined as an alias to the partiall-applied `#!hs map id`.

```haskell
mapId :: [a] -> [b]
mapId = map id
```

This is called *point-free* style.

## Sectioning

Partially applying infix operators is called *sectioning*.

!!! example "Sectioning"
    ```haskell
    addOne :: Num a => a -> a
    addOne = (+ 1)
    ```

    Here `#!hs (+ 1)` is the addition `#!hs (+)` partially applied with 
    `#!hs 1`. Since `#!hs (+)` is commutative, `#!hs (+ 1) == (1 +)`, but 
    `#!hs (- 2) /= (2 -)` since `#!hs (-)` is not commutative.

## Polymorphism

Polymorphic type variables allows expressions to work with arbitary types, so
we don't need to implement such expression for every type we need to it work 
with.

Haskell polymorphism is classified into:

1. **Parametric polymorphism**.
2. **Constrained polymorphism**.

Parametric polymorphism is more broad than constrained polymorphism since it
places less restrictions.

The identity function

```haskell
id :: a -> a
```

Is maximally polymorphic since it works with *any* data.

But `#!hs id` cannot do anything with `#!hs a` other than to return it because
it has no information on `#!hs a`.

When the type variable is constrained by a typeclass, it can take less types
but also comes with a set of operations which can be used on the argument.

Concrete types can be instances of multiple typeclasses, and typeclasses can
be superclasses of typeclasses. Such typeclasses are additive in nature in that
by becoming instances of typeclasses, one inherits their defined operations.

## Type Inference

Haskell's type inference is extended from the *Damas-Hindley-Milner* type 
system.

- Haskell tries to infer the most polymorphic / general type possible while
ensuring correctness.
