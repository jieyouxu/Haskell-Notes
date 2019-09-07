# Haskell Basics

## Prelude

The `Prelude` is a collection of standard library functions and typeclasses.
The Glasgow Haskell Compiler (GHC) has a default `Prelude`, but one is also able
to supply a custom `Prelude` if necessary.

## Type Signatures

The double colon operator `#!hs ::` denotes that some identifier "*has the
type*". That is, `#!hs id :: TypeName` denotes that some identifier `id`
has the type `#!hs TypeName`.

## Expressions

Haskell **expressions** may be:

- Values;
- Combination of values (e.g. arithmetic expressions); and/or
- Functions applied to values.

### Declarations

Haskell **declarations** are top-level *bindings* which assign names to
expressions, allowing programmers to refer to such expressions by names.

### Normal Form

*Expressions* are in **normal form** if no further reduction steps may be
performed (i.e. in *irreducible form*).

!!! example "Normal form"
    The expression `#!hs 1 + 1` is *not* in normal form since it can be reduced
    to `#!hs 2`, which is in normal form.

    This is done by applying the addition operator
    `#!hs (+) :: Int -> Int -> Int` to two arguments, two `#!hs 1`s.

!!! note "Redexes"
    *Reducible expressions* are also called **redexes**.

### Functions

Since Haskell functions follow those of lambda calculus, each function takes
only one argument. With **currying** — by applying a series of *nested*
functions with each taking one argument, the innermost expression can obtain
the values of multiple arguments.

Functions allow programmers to name arguments and the purposes of expressions.
This facilitates code reuse and documentation.

#### Function Definition

A **function definition** consists of:

- Name of function;
- Formal parameters;
- Assignment operator `#!hs =`;
- Body expression.

!!! example "Example function definition"
    In the function definition

    ```haskell
    double   x   =   x * 2
    -- [1]  [2] [3]   [4]
    ```

    - \[1\] is the function's name;
    - \[2\] is the single parameter's name;
    - \[3\] is the definition operator expressing equality;
    - \[4\] is the body expression.

## Evaluation

When some expression is *evaluated*, its terms are reduced until the simplest
irreducible form, i.e. **normal form**.

Haskell uses **lazy evalution** which avoids evaluation of terms unless it is
inevitable.

Haskell does *not* evaluate everything to normal form by default:

- It evaluates expressions to **weak head normal form** (WHNF) by default.

!!! example "Weak head normal form"
    For some expression like

    ```haskell
    (\x -> (1, 1 + x)) 1
    ```

    Haskell only evaluates to the next intermediate form 

    ```haskell
    (1, 1 + 1)
    ```

    Unless the final result `#!hs (1, 2)` must be evaluated.

## Infix Operators

By default, functions in Haskell are in *prefix* syntax.

**Operators** are functions which can be used in the *infix* style.

!!! example "Infix operator"
    The arithmetic addition operator `#!hs (+)` is an *infix* operator.

    It can also be used as a prefix function

    ```haskell
    (+) 1 2
    ```

    Which is identical to

    ```haskell
    1 + 2
    ```

    Some functions like `div` may be used infix by using backticks:

    ```haskell
    10 `div` 2 == div 10 2
    ```

### Associativity and Precedence

Precendence information on operators may be obtained from GHCi with the 
`#! :info` command. GHCi returns:

- Type information;
- Infix or prefix;
  - If infix, then its precedence and associativity;

!!! example "`#!hs :info (*)`"
    For the multiplication operator `#!hs (*)` GHCi returns

    ```haskell
    infixl 7 *
    ```

    - `#!hs infixl` means that the operator `#!hs (*)` is an *infix* operator
    and is *left* associative.
    - `#!hs 7` is `#!hs (*)`'s precendece level (between 0-9).
    - `#!hs *` is the operator's name, i.e. multiplication.

!!! note "Associativity"
    - Left Associativity

    For some left associative operator like `#!hs (*)`, an expression such as
    `1 * 3 * 5` is equivalent to `(1 * 3) * 5` with parentheses denoting
    evaluation order, from left to right.

    - Right Associativity

    For some right associative oerator like `#!hs (^)`, an expression such as
    `1 ^ 3 ^ 5` is equivalent to `1 ^ (3 ^ 5)`, from right to left.

## Value Declaration

In a Haskell source file `{filename}.hs`,

```haskell
-- file: arith.hs

module Arith where

addOne x = x + 1
```

- `fileName.hs` declares a module `Arith`.
- Module name is capitalized and named with `PascalCase`.
- Function, variable and parameter names use `camelCase`.

## Arithmetic Functions

| Operator    | Name      | Usage                                 |
| ----------- | --------- | ------------------------------------- |
| `#!hs (+)`  | Plus      | Addition                              |
| `#!hs (-)`  | Minus     | Subtraction                           |
| `#!hs (*)`  | Asterisk  | Multiplication                        |
| `#!hs (/)`  | Slash     | Fractional division                   |
| `#!hs div`  | Divide    | Integral division, round down         |
| `#!hs mod`  | Modulo    | Modulo division                       |
| `#!hs quot` | Quotient  | Integral division, round towards zero |
| `#!hs rem`  | Remainder | Remainder after division              |

### Negative Numbers

Because `#!hs (-)` is an operator, negative numbers may need parentheses to
disambiguate.

!!! example "Negative Integer"
    ```haskell
    100 + (-9)
    ```

## Dollar ($) Operator

The `#!hs ($)` operator has the signature

```haskell
($) :: (a -> b) -> a -> b
f $ a = f a
```

GHCi gives `#!hs infixr 0 $` upon using the `#!hs :info` command. It is right
associative, and of the lowest possible precedence. 

This operator helps to reduce the number of parentheses:

```haskell
(2^) (2 + 2) == (2^) $ 2 + 2
```

The binary arithmetic operators can be partially applied (e.g. `#! (2^)`),
and this is called **sectioning**.

## Let and Where
