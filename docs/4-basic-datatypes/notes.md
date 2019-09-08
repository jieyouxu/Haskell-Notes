# Basic Datatypes

## Types (Datatypes)

**Types** (or **datatypes**) introduces discipline in the inputs and outputs
of functions. They *restrict* what inputs and outputs can be — which provides
valuable information.

Types, when used properly, can help to accomplish more with less code.

Types are how similar values are grouped together by finding commonality.
Such commonality may be abstract.

## Data declaration

A type may be declared with:

- Datatypes are defined via *data declarations*.
- *Type constructor* is the name of the type.
- *Data constructors* are the values which may show up at the *term level*
instead of the *type level*.

## Bool Type

The datatype `#!hs Bool` represents the boolean values.

```haskell
data Bool = False | True
```

- `#!hs Bool` is the name of the type, and is the *type constructor*.
- `#!hs False` and `#!hs True` are the two *value constructors* which are the 
only possible values that the `#!hs Bool` type may take.
- The pipe `#!hs |` indicates *sum type* (i.e. either `#!hs False` or 
`#!hs True`).

## Numeric Types

Haskell has multiple numeric types, but the commonly used ones can be classified
into *Integral* numbers and *Fractional* numbers.

1. **Integral** numbers:

    - `#!hs Int`: fixed-precision integer.

    - `#!hs Integer`: arbitary-precision integer.

2. **Fractional** numbers:

    - `#!hs Float`: single-precision floating point number.

    - `#!hs Double`: double-precision floating point number.

    - `#!hs Rational`: fractional number which represents ratio between two
    integers; arbitary precision.

    - `#!hs Scientific`: space-efficient and almost-arbitary-precision, 
    represented via Scientific notation, with the coefficient being 
    `#!hs Integer` and exponent as `#!hs Int`.

All of such numeric types are instances of the `#!hs Num` **typeclass**.

- A **typeclass** adds functionality to types which shall be shared by instances
of such typeclass.

`#!hs Num` is the typeclass for these numeric types as the numbers share
operations such as `#!hs (+)`, `#!hs (-)`, `#!hs (*)`. Each instance specifies
how such operations behave with respect to the type.

The `#!hs minBound` and `#!hs maxBound` functions can be used to find the
min and max bounds for numeric types which are instances of the `#!hs Bounded`
typeclass.

## Comparing Values

Testing for *equality* (inequality) between two values which are of types that 
are instances of the `#!hs Eq` typeclass (i.e. values which have the notion of 
"equality"):

```haskell
-- Equality
(==) :: Eq a => a -> a -> Bool 
-- Inequality
(/=) :: Eq a => a -> a -> Bool 
```

Testing for *order* (less than, more than) between two values which are of types
that are instances of the `#!hs Ord` typeclass (i.e. values which have the notion 
of "order").

```haskell
-- Less than
(<) :: Ord a => a -> a -> Bool
-- More than
(>) :: Ord a => a -> a -> Bool
```

## Bool Functions and Operators

The boolean algebra functions and operators:

```haskell
-- Negation / not
not :: Bool -> Bool
-- And
(&&) :: Bool -> Bool -> Bool
-- Or
(||) :: Bool -> Bool -> Bool
```

## Conditionals

Haskell only has *if expressions* but not statements:

```haskell
if CONDITION
then EXPRESSION_A
else EXPRESSION_B
```

This expression reduces to `EXPRESSION_A` or `EXPRESSION_B` depending on
the `CONDITION`.

It is similar to ternary expressions in other languages such as JavaScript:

```javascript
(1 + 1 == 2) ? "Hello World" : "Goodbye World";
// -> "Hello World"
```

## Tuples

**Tuples** allows combining multiple values grouped up in one value. It is also
known as a *product type*, which represents conjunction — all constituents
are required to successfully construct the tuple type.

A *n-tuple* is said to have `n` constituents. For exmaple, a 2-tuple has
two components, `(x, y)`.

The number of constituents of a tuple is known as its *arity*.

Constituents of a tuple do not have to be of the same type.

### 2-tuple

A 2-tuple's datatype declaration is given by:

```haskell
(,) :: a -> b -> (a, b)
```

Convience functions, namely `#!hs fst` and `#!hs snd` allows easy extraction of
the first and second values out of the tuple respectively.

```haskell
fst :: (a, b) -> a
snd :: (a, b) -> b
```
