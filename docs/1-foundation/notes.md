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

And is applied to an *argument*, which is an input value. Hereafter a
lambda abstraction will be referred to as a "*lambda*" or an "*abstraction*" for
brevity.

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

### Alpha Equivalence

For some lambda abstraction such as

$$
    \lambda x \ldotp x
$$

The named variable $x$ has no semantic meaning apart from being a placeholder
for input values. Hence, it might as well be $a$ or $b$ or $c$, etc. This means
that the lambda terms

$$
    \lambda x \ldotp x 
        \Leftrightarrow \lambda y \ldotp y
        \Leftrightarrow \lambda \beta \ldotp \beta
$$

Have **alpba equivalence** — they are the same function.

### Beta Reduction

Upon applying a function to an argument, all occurrences of the bound variable
within the body (that is the parameter) are substituted with the input
expression. The head can safely be eliminated as it only serves the purpose
of binding a name to the parameter.

!!! example
    For the abstraction

    $$
        \lambda x \ldotp x
    $$

    If the abstraction is applied to $2$, then:

    1. Substitute $2$ for every occurrence of $x$ in the body.
    2. Eliminate the head.

    That is,

    $$
        \begin{aligned}
            (\lambda x \ldotp x)\ 2 & \\
            2 & \\
        \end{aligned}
    $$

!!! note "Identity function"
    The previous example function $\lambda x \ldotp x$ is the **identity
    function** since it simply returns whatever input expression was given to
    it.

    This is like $f(x) = x$.

To denote precedence, let parentheses $()$ be used to group the body expression
of an abstraction.

!!! example "Parentheses showing precedence"
    $$
        (\lambda x \ldotp x + 1)
    $$

    Here the body expression is $x + 1$.

A lambda abstraction can also be applied to another lambda abstraction. Square
brackets $[]$ shall be used to denote substitution.

!!! example "Square brackets showing substitution"
    $$
        \newcommand{\coloneq}{\mathrel{\vcenter{:}}=}
        \begin{aligned}
            (\lambda x \ldotp x)(\lambda y \ldotp y) & \\
            [x \coloneq (\lambda y \ldotp y)] & \\
            (\lambda y \ldotp y) & \\
        \end{aligned}
    $$

!!! note "Associativity of application"
    **Applications** in lambda calculus are *left associative* from the right
    to the left.

!!! example "Left associativity of lambda application"
    $$
        (\lambda x \ldotp x)(\lambda y \ldotp y) z
        \Leftrightarrow
        ((\lambda x \ldotp x)(\lambda y \ldotp y))z
    $$

    This expression may be reduced as

    $$
        \newcommand{\coloneq}{\mathrel{\vcenter{:}}=}
        \begin{aligned}
            (\lambda x \ldotp x)(\lambda y \ldotp y) z & \\
            [x \coloneq (\lambda y \ldotp y)] & \\
            (\lambda y \ldotp y) z \\
            [y \coloneq z] \\
            z
        \end{aligned}
    $$

#### Free Variables

The *head* of an lambda abstraction provides information on which named variable
is bounded to be in scope when the function is applied.

Those variables in the expression body which are not named in the head are
**free variables**.

!!! example "Free variable"
    In the lambda abstraction

    $$
        \lambda x \ldotp x y
    $$

    $y$ is a *free variable* as it is not named in the head. It cannot be
    reduced when the function is applied to an argument.

!!! example "Applying lambda abstraction to a variable"
    The lambda abstraction

    $$
        \lambda x \ldotp x y
    $$

    Can be applied to some variable $z$

    1. $(\lambda x \ldotp x y) z$.
        
        The lambda can be applied to the argument $z$.

    2. $(\lambda [x \coloneq z] \ldotp x y)$.
        
        $x$ is the bound variable and its instances shall be replaced by $z$,
        with the head being eliminated.

    3. $z y$.
        
        Head was eliminated and no more heads are left, and since $z$ and $y$ 
        are free variables no further reductions may be applied.
