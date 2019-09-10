# Algebraic Datatypes (ADTs)

A **type** is an enumeration of data constructors which each have zero or
more arguments.

Haskell has:

- Sum types
- Product types
- Product types via record syntax
- Type aliases
- Newtype

## Data and Type Constructors

Haskell has *type constructors* and *data constructors*:

- *Type constructors* used only at type level, signatures and typeclass 
declaration and instances; static and resolved at compile time.
- *Data constructors* construct values at term level; resolved at run time.

Type *constants* refer to types which do not take additional parameters, for
example `#!hs Bool`.

```haskell
data Bool = False | True
```

Type *constructors* refer to types which take additional type parameters, for
example `#!hs Maybe a`.

```haskell
data Maybe a = Nothing | Just a
```

## Type Constructors and Kinds

**Kinds** are the types of types, represented in `#!hs *`. When some type is
a fully applied concrete type, its kind is `#!hs *`. When some type is awaiting
a concrete type to be supplied, it has the kind `#!hs * -> *`, like a function.

!!! note "Kind information"
    The GHCi can provide kind information via `#!hs :kind` or `#!hs :k`.

    ```haskell
    Prelude> :k Bool
    Bool :: *

    Prelude> :k []
    [] :: * -> *

    Prelude> :k Maybe
    Maybe :: * -> *
    ```
    
    Notice that `#!hs []` is not a concrete type since it still needs to be
    applied to some concrete type — hence, this is what the *constructor* in
    the name *type constructor* is referring to.

## Data Constructors and Values

Similar to type *constants* and type *constructors*, there are also differences
between data *constructors* and *constant* values.

```haskell
data Maybe a = Nothing | Just a
```

Here, `#!hs Maybe` is a type constructor since it is awaiting a type argument
`#!hs a` and `#!hs Maybe` has the kind `#!hs Maybe :: * -> *`.

It is a sum type of an constant and a data constructor:

- `#!hs Nothing` is a constant value.
- `#!hs Just a` is a data constructor.

## Type vs Data

Haskell types are static and resolved at compile time, while data are what gets 
passed around at run time. Haskell type information do not persist through to
run time.

Haskell compilation causes a phase separation to occur:

1. Compile time: type constructors
2. Run time: data constructors

## Data Constructor Arity

**Arity** refers to the number of arguments a function or constructor has.

| Number of Arguments | Adjective |
| ------------------- | --------- |
| 0                   | Nullary   |
| 1                   | Unary     |
| 2                   | Binary    |
| 3                   | Ternary   |

Data constructors with more than one argument is called a *product type*.

## Algebraic

Haskell datatypes are *algebraic* because they can be described their argument
structure using the two operations *sum* and *product*.

The datatypes are called *sum* and *product* based on how their **cardinality**
is calculated, like that of finite set theory.

The *cardinality* of a datatype is the number of possible values that it defines,
from $0$ to possibly $\infty$.

If cardinality of a datatype is calculated, it is possible then to determine
how many different possible implementations there are of a function for a given
type.

!!! example "`#!hs Bool`"
    The `#!hs Bool` type is a sum type defined by two nullary data constructors.

    This means that there are only two possible values for the `#!hs Bool` 
    datatype: either `#!hs True` or `#!hs False`. Hence, the cardinality of
    `#!hs Bool` is $2$.

!!! example "`#!hs Int8`"
    The `#!hs Int8` type can take 8-bits of data, which is $256$ different 
    combinations. Hence, its cardinality is $256$.

## Newtype

The `#!hs newtype` keyword restricts the type declaration to a single data
constructor. Hence, the cardinality of the type is exactly equivalent to the
cardinality of its sole data constructor.

A `#!hs newtype` cannot be a product type, sum type or contain nullary
constructors. However, it has zero runtime overhead, as it cannot be a record
(product type) or tagged union (sum type). Its presence is erased at run time.

`#!hs newtype` allows an additional layer of differentiation in the type level,
even if the underlying contained types are identical.

??? example "Newtype"
    ```haskell
    newtype LineNumber = LineNumber Int
    newtype ColumnNumber = ColumnNumber Int

    showLineNumber :: LineNumber -> String
    ```

    Passing a `#!hs ColumnNumber` to `#!hs showLineNumber` causes type-checking
    to fail since a `#!hs ColumnNumber` is *not* a `#!hs LineNumber` even if
    their underlying type is the same `#!hs Int` type.

If it is necessary to reuse the typeclass instance of the underlying type,
one may use the GHC language extension `GeneralizedNewtypeDeriving`

```haskell
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
newtype LineNumber = LineNumber Int
```

## Sum Types

To calculate the cardinality of the type built from multiple data constructors,
we add the cardinalities of each data constructor.

!!! example "Cardinality of Bool"
    ```haskell
    data Bool = False | True
    ```

    `#!hs Bool` is a sum type built from two data constructors, `#!hs False`
    and `#!hs True`. Its cardinality is the cardinality of `#!hs False` ($1$)
    plus the cardinality of `#!hs True` ($1$), hence $1 + 1 = 2$.

## Product Types

The cardinality of a product type is the product of its constituents.

!!! example "Cardinality of (Bool, Bool)"
    ```haskell
    data BB = BB (Bool, Bool)
    ```

    The cardinality of the type `#!hs BB` is equivalent to its sole data
    constructor `#!hs BB`, which comprises of the single argument 
    `#!hs (Bool, Bool)`. The cardinality of `#!hs (Bool, Bool)` is the product
    of its two constituents, both `#!hs Bool`. Hence, the cardinality of 
    `#!hs (Bool, Bool)` is $2 \times 2 = 4$ and so the cardinality of
    `#!hs BB` is also $4$.

### Record Syntax

Compared to *anonymous product type* (i.e. tuples since their constituents are
not named), **records** name each of its constitutents.

```haskell
data Person = Person { name :: String
                     , age  :: Int
                     }
```

To calculate `#!hs Person`'s cardinality, we first note that `#!hs Person` has
a sole data constructor of the same name. The data constructor `#!hs Person`'s
cardinality is further equivalent to the product of the cardinality of its
two constitutents.

## Function Type

For some function of type `#!hs a -> b`, its cardinality is the exponentiation
${\lvert b \rvert} ^ {\lvert a \rvert}$.

## Higher-kinded Datatypes

Kinds are *not* types unless fully applied to be `#!hs *`. Kinds such as
`#!hs * -> *` and `#!hs * -> * -> *` are waiting for one and two type
arguments respectively before they become types, and are known as 
**higher-kinded** types.

Type arguments can be used to express "hole"s to be filled in.

## Binary Tree

A recursive datatype is the binary tree.

```haskell
data BinaryTree a =
      Leaf
    | Node (BinaryTree a) a (BinaryTree a)
    deriving (Eq, Ord, Show)
```

Insertion into a binary tree depends on ordering:

```haskell
insertBt :: Ord a 
         => a
         -> BinaryTree a
         -> BinaryTree a
-- Base case: create a new b-tree from an empty tree consisting of a single leaf
insertBt b Leaf = Node Leaf b Leaf
insertBt b (Node left a right)
    | b == a = Node left a right
    | b < a  = Node (insertBt b left) a right
    | b > a  = Node left a (insertBt b right)
```

## As-Pattern

As-pattern `#!hs @` allows binding a named to the destructued value.

```haskell
printSnd :: (a, b) -> IO b
printSnd tuple@(_, b) = do
    print tuple
    return b
```
