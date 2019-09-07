# digits

This package performs arbitrary precision integer arithmetic. It is a functional approach to arbitrary precision integers. 
Most of the methods are recursive methods 
with just a single `switch` statement. 

It contains one main enumeration: `BinaryInteger`.

# `BinaryInteger`

`Binary` is just a linked list. It is a linked list whose elements are ones and zeros and the tail is either `.empty(.postive)` or `.empty(.negative)`.
The `positive` one indicates an infinite stream of zeros whereas the `negative` one indicates an infinite stream of ones.
It represents an arbitrary precision integer. It supports positive powers, addition, subtraction, multiplications, division, and modulus.

# Inspiration

I'm a big fan of functional programming because it feels so 
mathematical. I was inspired to create this repository when I was reading through
[this](https://www.amazon.com/Purely-Functional-Data-Structures-Okasaki/dp/0521663504/ref=sr_1_1?gclid=CjwKCAjwqZPrBRBnEiwAmNJsNiVjfhYaNy3LUWPTjUEH-i27A4PkM8PGBnRdw_geaNaNboIruoSxHxoCqHIQAvD_BwE&hvadid=177125465882&hvdev=c&hvlocphy=9033251&hvnetw=g&hvpos=1t1&hvqmt=e&hvrand=9983164985864541960&hvtargid=aud-646675774026%3Akwd-1395405452&hydadcr=16434_9739212&keywords=purely+functional+data+structures&qid=1566963279&s=gateway&sr=8-1) 
book and translating the examples from Standard ML into Swift.
