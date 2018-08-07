# Binary Numbers
Just a toy example of binary arithmetic I created as a quick exercise.

The numbers are printed to the screen as normal binary number strings, but internally the are stored as lists of `BinaryCharacter` values which can be either `One` or `Zero`. Addition, etc, is performed by operating on these binary values. It's not a very efficient way of doing things.

## Useage

No one in their right mind would want to use this, but binary numbers can be constructed as follows

```
>>> BinaryNumber [One, Zero, Zero]
100
>>> 1234::BinaryNumber
10011010010
>>> stringToBinary "1011"
Just 1011
>>> stringToBinary "123"
Nothing
```

Technically `BinaryNumbers` are in the `Num` class but they do not support all opeations. `(+)`, `signum` and `abs` are supported, though as `BinaryNumbers` are never negative `abs` is the same as `id`.

```
>>> let a = 123::BinaryNumber
>>> a
1111011
>>> a + 2
1111101
>>> let b = stringToBinary "1111011"
>>> fmap (+2) b
Just 1111101
```
