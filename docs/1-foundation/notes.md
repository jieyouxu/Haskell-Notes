# Foundations

A **calculus** is a method of *calculating* or *reasoning*.

**Lambda calculus** formalizes *effective computability*.

## Functional Programming

**Functional programming** (FP) is a programming paradigm relying on
*functions* modeled on *mathematical functions*.

*Programs* in FP are composed from **expressions**, which can be:

- *Values*;
- *Variables*;
- *Functions*.

**Functions** are expressions which are *applied* to an *argument*/*input*,
which can be *reduced* or *evaluated*. *Functions* are *first-class* in Haskell,
such that they can be used as:

  - *Values*;
  - Passed as *arguments*/*inputs* to other functions.

**Purity** in FP can mean *referential transparency*:

  - Given a function $f$, if it is given the same input $x$, it will always
  return the same output $y$, like a mathematical function.

**Abstraction** allows writing shorter code by extracting common/repeated
constructs into more reusable, generic code.

  - High levels of *abstraction* allows programmers to *compose* programs from
  separate functions.

## Functions

A **function** is the *relation* between a set of possible *inputs* and a set of
possible *outputs*. Function *application* maps input(s) to an output.

!!! example
    Given some function $f$, with the input set (**domain**) $\{ 1, 2, 3 \}$ and
    the output set (**codomain**) $\{ A, B, C \}$, with $f$ defined as

    $$
    \begin{aligned}
        f(1) &= A \\
        f(2) &= B \\
        f(3) &= C \\
    \end{aligned}
    $$

Then $f$ is *referentially transparent* — for instance, when $f$ receives input
$1$ it always outputs $A$. This ensures that the function is in fact
*predictable*.

!!! note
    For OOP languages like Java, objects often constitute of shared mutable 
    state. This can make testing and debugging very difficult because for some
    input, a method on an object does not necessarily return the same output.

The previous example only defined a mapping, but not necessarily a relationship
between its input and output.

!!! example
    Given some function $f$, let it be defined as

    $$ f(x) = \underbrace{x + 1}_{\text{function body}} $$

    The function $f$ takes a single named argument $x$. $f$ describes the
    relationship between the input $x$ and output (which is described in the 
    *function body*).

    Upon applying the function $f$, we substitute its argument $x$ for a
    concrete value, for instance $1$. Then $f(1) = 1 + 1 = 2$. This establishes
    a mapping $f(1) \mapsto 2$.
