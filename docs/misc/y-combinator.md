# Y Combinator

Notes on Y combinator from [mvanier](https://mvanier.livejournal.com/2897.html).

## Explicit Recursion

Pure lambda calculus do not have named expressions. And so one cannot call
some function with its name (because it does not have a name) to achieve
*explicit recursion*. However, *implicit recursion* is possible through the
means of using Y combinator(s).

## Y Combinator Basics

The Y combinator is:

- A higher-order function:
    - Takes a single non-recursive function.
    - Returns a version of it which is recursive.
- That is, it generates recursive functions from non-recursive functions.
- This means that programming language definitions do not have to explicitly
support recursion!

There are infinite number of Y combinators but only one lazy and one strict
Y combinators will be discussed:

- *Lazy* Y combinator is known as the **normal-order Y combinator**.
- *Strict* Y combinator is known as the **applicative-order Y combinator**.

## Lazy Evaluation vs Strict Evaluation

Lazy evaluation:

- Only evaluating as much of the expression as necessary to get the final 
result.

Strict evaluation:

- All of the expression will be evaluated before the overall value is 
determined.

## Static Typing vs Dynamic Typing

It is easier to define a Y combinator for dynamically strong typed languages,
which is the Y combinator defined here.

## Combinator

A **combinator** is a *lambda expression* with *no free variables*.

Given some factorial function

```scheme
(define factorial
    (lambda (n)
        (if (= n 0)
            1 
            (* n (factorial (- n 1))))))
```

In terms of its lambda expression

```scheme
(lambda (n)
    (if (= n 0)
        1 
        (* n (factorial (- n 1)))))
```

Is *not* a combinator because there are free variables:

- `#!scheme =`
- `#!scheme *`
- `#!scheme factorial`
- `#!scheme -`

(Also the numbers are not even considered.)

To convert this into a combinator, we need to abstract out offending free
variables.

First of all, the recursive call to `#!scheme factorial` needs to be pulled out:

```scheme hl_lines="2 6"
(define almost-factorial
    (lambda (f)
        (lambda (n)
            (if (= n 0)
                1 
                (* n (f (- n 1)))))))
```

With the recursive parts extracted, the yet-to-be-defined Y combinator
can be used to add in recursion in the necessary place:

```scheme
(define factorial (Y almost-factorial))
```

Assume there is some working factorial function `#!scheme factorialA`.

```scheme
(define factorialB (almost-factorial factorialA))
```

If `#!scheme factorialA` is substituted in,

```scheme
(define factorialB
    ((lambda (f)
        (lambda (n)
            (if (= n 0)
                1
                (* n (f (- n 1))))))
    factorialA))
```

And when `#!scheme factorialA` is substituted for `#!scheme f`

```scheme
(define factorialB
    (lambda (n)
        (if (= n 0)
            1
            (* n (factorialA (- n 1)))
        )
    )
)
```

Which should work if `#!scheme factorialA` works, except it does not yet exist.

But if we assume `#!scheme factorialA` to be a valid factorial function, then
pass it to `#!scheme almost-factorial`, and name the result to also be
`#!scheme factorialA`

```scheme
(define factorialA (almost-factorial factorialA))
```

This definition is valid *iff* the language uses lazy evaluation, and works!

For strict evaluation though, a slightly different approach is necessary.

Let there be defined several helper functions

```scheme
(define identity (lambda (x) x))
(define factorial0 (almost-factorial identity))
```

Notice that `#!scheme factorial0` is able to compute *some* factorials, namely
the case when $n = 0$.

??? note "`#!scheme (factorial0 0)`"
    ```scheme
    (factorial0 0)

    ; ==>
    ((almost-factorial identity) 0)

    ; ==>
    (
        (
            (lambda (f)
                (lambda (n)
                    (if (= n 0)
                        1
                        (* n (f (- n 1)))))
        ) identity)    
        0
    )

    ; ==>
    (
        (lambda (n)
            (if (= n 0)
                1
                (* n (identity (- n 1)))))  
        0
    )

    ; ==>
    (
        (if (= 0 0)
            1
            (* 0 (identity (- 0 1))))
    )

    ; ==>
    (
        (if #t
            1
            (* 0 (identity (- 0 1))))
    )

    ; ==>
    1
    ```

??? example "Fibonacci"
    ```haskell
    fibonacci 0 = 0
    fibonacci 1 = 1
    fibonnaci n = fibonacci (n - 1) + fibonacci (n - 2)
    ```

    Or equivalently in Scheme

    ```scheme
    (define fibonacci
        (lambda (n)
            (cond ((= n 0) 0)
                  ((= n 1) 1)
                  (else (+ (fibonacci (- n 1) (fibonacci (- n 2))))))))
    ```

    We can pull out the recursive function call to give an `almost-` version

    ```scheme hl_lines="2 6"
    (define almost-fibonacci
        (lambda (f)
            (lambda (n)
            (cond ((= n 0) 0)
                  ((= n 1) 1)
                  (else (+ (f (- n 1) (f (- n 2))))))))))
    ```

    And the Y combinator can be reused here

    ```scheme
    (define fibonacci (Y almost-fibonacci))
    ```

Let `#!scheme factorial1` be defined as

```scheme
(define factorial1 (almost-factorial factorial0))
; which is equivalent to
(define factorial1 (
    (almost-factorial (
        almost-factorial identity
    ))
))
```

This will correctly compute factorials for $n = 0$ and $n = 1$, but not
$n > 1$.

This process can be repeated:

```scheme
(define factorial2 (almost-factorial factorial1))
(define factorial3 (almost-factorial factorial2))
(define factorial4 (almost-factorial factorial3))
; ...
```

Expanded, it looks like

```scheme
(define factorial-infinity
    (almost-factorial
        (almost-factorial
            (almost-factorial
                ;....
                (almost-factorial identity)
            ))))
```

Now to get it working for all $n \in \mathbb{z}$, we need to repeat the chain
of `#!scheme almost-factorial` an infinite number of times; 
`#!scheme factorial-infinity` is the factorial function we are looking for.

If we can define an infinite chain of `#!scheme almost-factorial`s, it will
give us the desired factorial function – such factorial function is the
**fixpoint** of `#!scheme almost-factorial`.

## Fix-point of Functions

If one keeps on trying to apply $\cos$ to $0$ (i.e. $\cos (\cos ( \dots \cos (0) \dots ))$)
in a calculator, one will find that it converges to approximately 
$0.73908513321516067$. Applying $\cos$ to $0.73908513321516067$ again does not
change the output ($\cos (0.73908513321516067) \approx 0.73908513321516067$).
Here $0.73908513321516067$ is the *fix-point* of the cosine function.

Since the cosine function has the type $\cos :: \mathbb{R} \to \mathbb{R}$
(or of the shape `#!hs a -> a` where input type matches output type), it can 
repeatedly be applied to itself.

Fixpints do not have to be numbers, so as long as the generating function
has identical input/output type, and may be functions.

The fixpoint function for `#!scheme almost-factorial` shall be the function
such that

```scheme
fixpoint-function = (almost-factorial fixpoint-function)
```

Repeatedly substituting the right hand side of `#!scheme fixpoint-function` as
the input to `#!scheme almost-factorial`, one yields

```scheme
fixpoint-function = 
    (almost-factorial 
        (almost-factorial fixpoint-function))

; =
(almost-factorial 
    (almost-factorial 
        (almost-factorial fixpoint-function)))

; =
(almost-factorial 
    (almost-factorial 
        (almost-factorial
            (almost-factorial ... ))))
```

This is in fact the desired factorial function – the fixpoint of
`#!scheme almost-factorial` is the `#!scheme factorial` function.

```scheme
factorial = 
    (almost-factorial factorial)

; =
(almost-factorial 
    (almost-factorial 
        (almost-factorial 
            (almost-factorial ...))))
```

Y is also the **fixpoint combinator** since it takes a function and returns
its fixpoint.

## Eliminating Explicit Recursion (Lazy)

Let Y be specified as

```scheme
(Y f) = fixpoint-of-f
```

```scheme
(f fixpoint-of-f) = fixpoint-of-f
```

```scheme
(Y f) = fixpoint-of-f = (f fixpoint-of-f)
```

`#!scheme (Y f)` can be substituted for `#!scheme fixpoint-of-f`:

```scheme
(Y f) = (f (Y f))
```

Which is the definition of Y:

```scheme
(define (Y f) (f (Y f)))

; or equivalently

(define Y
    (lambda (f)
        (f (Y f))))
```

Note that this definition of Y:

1. Only works in lazy language.
2. *Not* a combinator since `#!scheme Y` in body is a free variable.

## Eliminating Explicit Recursion (Strict)

In a strict language, trying to evaluate `#!scheme (Y f)` would fail since

```scheme
(Y f)
= (f (Y f))
= (f (f (Y f)))
= ...
```

But since `#!scheme (Y f)` will become a function of a single argument, 
the equality below will hold:

```scheme
(Y f) = (lambda (x) ((Y f) x))
```

Which goes on to give the definition

```scheme
(define Y
    (lambda (f)
        (f (lambda (x) ((Y f) x)))))
```

Since `(lambda (x) ((Y f) x)) == (Y f)` this version of Y is valid.

This version will also work with strict languages because the inner 
`#!scheme (Y f)` is contained within a lambda whose execution is delayed.

## Deriving the Y Combinator

The previous versions of Y are not yet combinators since the `#!scheme Y` in
the body expressions is a free variable.

## Normal-order (Lazy) Y Combinator

Given the original recursive `#!scheme factorial` function where

```scheme
(define (factorial n)
    (if (= n 0)
        1
        (* n (factorial (- n 1)))
    )
)
```

To get rid of the explicit recursion, we can pass the `#!scheme factorial` 
function itself as an additional argument when the function is called.

```scheme
;; not working yet
(define (part-factorial self n)
    (if (= n 0)
        1
        (* n (self (- n 1)))
    )
)
```

The `#!scheme part-factorial` needs to be called differently:

```scheme
(part-factorial part-factorial 5) == 120
```

This is no longerly explicitly recursive because an extra copy is sent along
via `#!scheme self`. But it needs to modified to become:

```scheme
(define (part-factorial self n)
    (if (= n 0)
        1
        (* n (self self (- n 1)))))
```

Which can be rewritten as

```scheme
(define (part-factorial self)
    (lambda (n)
        (if (= n 0)
            1
            (* n (self self (- n 1))))))
```

Which can be invoked like

```scheme
((part-factorial part-factorial) 5) == 120
```

```scheme
(define factorial (part-factorial part-factorial))
(factorial 5) == 120
```

Notice that a factorial function is already defined without explicit recursion.

To get it to look something like `#!scheme almost-factorial`, the 
`#!scheme (self self)` invocation may be extracted using a `#!scheme let` 
binding.

```scheme
(define (part-factorial self)
    (let ((f (self self)))
        (lambda (n)
            if (= n 0)
                1
                (* n (f (- n 1))))))
```

Which will work in a lazy language (but not yet for a strict language; the
`#!scheme let` binding can be wrapped inside a lambda to delay execution, which
will fix the infinite loop issue).

Any `#!scheme let` expression may be transformed into an equivalent
`#!scheme lambda` expression through:

```scheme
(let ((x <expression_1>)) <expression_2>)
== ((lambda (x) <expression_2>) <expression_1>)
```

Using this equality, the `#!scheme part-factorial` can be transformed into

```scheme
(define (part-factorial self)
    ((lambda (f)
        (lambda (n)
            (if (= n 0)
                1
                (* n (f (- n 1)))))) 
    (self self)))

(define factorial (part-factorial part-factorial))
```

Notice the `#!scheme almost-factorial` contained inside:

```scheme
(define almost-factorial
    (lambda (f)
        (lambda (n)
            (if (= n 0)
                1
                (* n (f (- n 1)))))))
```

Which means that `#!scheme part-factorial` can be rewritten in terms of
`#!scheme almost-factorial`:

```scheme
(define part-factorial
    (lambda (self)
        (almost-factorial (self self))))
```

And so the `#!scheme factorial` function can be rewritten as:

```scheme
(define factorial
    (let ((part-factorial (lambda (self)
            (almost-factorial (self self)))))
        (part-factorial part-factorial)))
```

We can rename `#!scheme part-factorial` to `#!scheme x` to give:

```scheme
(define factorial
    (let ((x (lambda (self)
            (almost-factorial (self self)))))
        (x x)))
```

The let-to-lambda conversion technique can be used here as well:

```scheme
(define factorial
    ((lambda (x) (x x))
        (lambda (self)
            (almost-factorial (self self)))))
```

We can again rename `#!scheme self` to `#!scheme x`:

```scheme
(define factorial
    ((lambda (x) (x x))
        (lambda (x)
            (almost-factorial (x x)))))
```

We can change `#!scheme factorial` into a more generic function
`#!scheme make-recursive` which makes recursive functions out of
non-recursive functions:

```scheme
(define (make-recursive f)
    ((lambda (x) (x x))
        (lambda (x) (f (x x)))))
```

`#!scheme make-recursive` is in fact the normal-order (lazy) Y combinator:

```scheme
(define (Y f)
    ((lambda (x) (x x))
        (lambda (x) (f (x x)))))
```

Which can be expanded to

```scheme
(define Y
    (lambda (f)
        ((lambda (x) (f (x x)))
            (lambda (x) (f (x x))))))
```

### Applicative-order (Strict) Y Combinator

```scheme
(define (part-factorial self)
    (let ((f (lambda (y) ((self self) y))))
        (lambda (n)
            (if (= n 0)
                1
                (* n (f - n 1))))))
```

Which simplies to:

```scheme
(define Y
    (lambda (f)
        ((lambda (x) (x x))
            (lambda (x) (f (lambda (y) ((x x) y)))))))
```

And so the factorial function can be defined as:

```scheme
(define factorial (Y almost-factorial))
```

An implementation of applicative-order Y-combinator in JavaScript is:

```javascript
const Y = f => (x => x(x))(y => f(x => y(y)(x)));

const factorial = Y(
    self => n => {
        if (n == 0) return 1;
        else return n * self(n - 1);
    }
);
```
