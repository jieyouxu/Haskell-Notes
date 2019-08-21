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

**Purity** in FP can mean **referential transparency**:

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

Then $f$ is **referentially transparent** — for instance, when $f$ receives input
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

## Structure of Lambda Calculus

The *lambda calculus* comprises three **lambda terms**:

1. Expressions
2. Variables
3. Abstractions

An **expression** is either one of the three lambda terms or a combination of
them (hence an inductive definition).

- The simplest expression is a single variable, which has no meaning or value
and are simply placeholder names for inputs.

An **abstraction** is a *function*; it has

- A *head* (a *lambda*)
- A *body*

And is applied to an *argument*, which is an input value.

!!! note "Abstraction"
    An **abstraction** is built from a **head** and a **body**.

    The **head** of a function is a $\lambda$ followed by a variable name.

    The **body** is another *expression*.

!!! example "Simple abstraction"
    $$
        \lambda x \ldotp x
    $$

    The variable $x$ named in the head is the abstraction's *parameter* which 
    *binds* all occurrences of $x$ in the body.

    When the abstraction is applied with an input value $v$ given to $x$, all
    occurrences of $x$ in the body takes on that input value $v$.

    In the abstraction, the $\lambda x$ part is the *head*, the $x$ in the
    head is the single *parameter*, and the $x$ to the right of the $\ldotp$ is
    the body. Note that the $x$ in the body is *bound* by the parameter of the
    same name. The dot $\ldotp$ acts as a separator.

!!! note "Anonymous function"
    The previous example's lambda abstraction $\lambda x \ldotp x$ does not
    have a name, hence it is *anonymous*. Hence it cannot be called by name.

    It is called an *abstraction* since it is a generalization of a concrete
    problem, and names given to it allows abstraction — abstracting away from
    tiny details to simplify the cognitive burden and facilitates code reuse.
    By using named variables, we can reuse the abstraction for potentially
    many instances of similar problems.
