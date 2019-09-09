# Recursion

==To understand recursion scroll to the bottom of this page.==

Recursion refers to defining a function with regard to itself using
self-referential expressions – the function will keep on calling itself unless
some condition is reached, or else it never terminates (theoretically).

Lambda calculus do *not* have recursion since expressions are nameless and so
cannot be called. But to achieve Turing completeness, one needs to be able to
write recursive functions.

The *Y combinator* or *fixed-point combinator* is used to write recursive
functions in lambda calculus.

## Factorial

!!! example "Broken Factorial"
    A naïve implementation of the factorial function may be:

    ```haskell
    brokenFactorial :: Integer -> Integer
    brokenFactorial n = n * brokenFactorial (n - 1)
    ```

    But trying to apply this function to any integer never terminates...

    ```haskell
    brokenFactorial 3 = 3 * (3 - 1) * ((3 - 1) - 1) * ...
    ```

    Because this implementation has *No Base Case™*.

!!! example "Better Factorial"
    A better implementation for factorial may be:

    ```haskell
    factorial :: Integer -> Integer
    factorial 0 = 1
    factorial n = n * factorial (n - 1)
    ```

    Which will terminate because eventually the base case will be reached
    and no more calls to itself will be made.

    ```haskell
    factorial 3     = 3 * (factorial 2)
                    = 3 * (2 * (factorial 1))
                    = 3 * (2 * (1 * (factorial 0)))
                    = 3 * (2 * (1 * (1)))
                    = 3 * (2 * (1 * 1))
                    = 3 * (2 * (1))
                    = 3 * (2 * 1)
                    = 3 * (2)
                    = 3 * 2
                    = 6
    ```

    With only one slight caveat – negative integers are not handled.

==To understand recursion scroll to the top of this page.==
