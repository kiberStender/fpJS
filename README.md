fpJS
====

## Base
Functional paradigm is a programming style where you do not have the concept of variables as a mutable thing across the code,
but as a thing that can born with a different value each time. For example think about a math function

```haskell
  f x = x + 1
  a = f 3 -- 4
  b = f 5 -- 6
```

Notice that x borns with a different value each time we call the function, but it never changes its value. That's the core idea of 
functional paradigm. This helps a lot for us do maintain the code, because we can easily track the variable values and for
advanced language compilers like scala and haskell it helps to make the compiler your friend warning you about problems that may
occur. 

### About functions

The functional paradigm is based on math statements, so you can use all of its rules to help you coding and by default, if you pay 
attention a math variable is nothing more than a function without parameter.

```x = 3```

Tranlslates to

```coffeescript
  x = -> 3
```

Functions has a lot of advantages that we do not have with variables. For example, we can compose that:

```haskell
  f x = x + 4
  g x = x / 2

  h = (f o g) 2 -- (2 + 4) / 2 == 3 or f(g(2))
  i = (g o f) 2 -- (2 / 2) + 4 == 5 or g(f(2))
  -- "o" is the math symbol for compose
```

Did you see how it makes simple? In fact FpJs implement its own version of compose in a OO style, and has the opposite
implementation too, called andThen. See for yourself

```coffeescript
  f = (x) -> x + 4
  g = (x) -> x / 2

  h = (f.compose g) 2 # (2 + 4) / 2 == 3 or f g 2
  i = (f.andThen g) 2 # (2 / 2) + 4 == 5 or g f 2
```

Here you only had to change function names, but it is the same example as the above. Using coffeescript syntax we can
make the code even simpler and much more, using a simple feature called "currying" to make the app faster and simpler to read.
Currying is the ability to split a many parameter function in a function who has only one parameter and returns another 
one parameter function until all the parameters are mapped.

```coffeescript
  #instead of
  sum = (a, b) -> a + b
  #with currying
  sumC = (a) -> (b) -> a + b
  # function sumC(a){ return function(b){return a + b;}} in javascript
  a = sum(2, 3) # 5
  b = sum(2)(3) # 5 duh!
```

But how doing this can make our code faster? Imagine the following situation:

```coffeescript
  sum = (a, b) -> a + b
  sumC = (a) -> (b) -> a + b
  
  sum2 = (a) -> sum(2, a)
  sum2C = (a) -> sumC(2)(a)
```

What is the difference besides how it is called? Do you remember all functions are lazy right? So it will only process when you call it,
with this in mind think about the sum2 function. It will call sum with the first parameter hardcoded right? But not exactly. 
Before it sums the two number 'a' and 'b', it will have to evaluate  b from sum2 and then reevaluate 'a' and 'b', so it will be a 
three times execution. Now think about the sum2C. When you call sumC(2) it will returns another function with 'a' parameter already 
evaluated, so only 'b' will be processed. Only 2 steps, only 2 evaluations. So you can have a better re utilization, a better 
composition and an increased performance. But you can have a better readable code too writing less code.

```coffeescript
  sumC = (a) -> (b) -> a + b
  sum2C = sumC 2
  alert sum2C 3 # 5
```

What? What that means? sumC function returns a function with one parameter right? So you don't need to wite it again. With this caveat we
can write less code and remember this words young code padawan: The less you code it, the less you fix it


## Lazy values

Scala has a feature called lazy val. It initializes a variable only when it is called for the first time. Never before, never after.
And because of its immutable nature, it becomes a singleton object. It is good to have a "global" variable in a certain context 
and initialize it only when it is needed but Coffeescript has no such feature, so I created a function named "lazy" to simulate this behavior.

```coffeescript
  a = lazy -> 10 # i makes 'a' a lazy evaluable variable which returns 10
  console.log a()  # This will print 10
  # This is a limitation we have to deal. By default Scala support parenthesesless function call
  # (Does this word exist?)  but coffeescript does not
```

## Ordering
I know javascript has it's own way of ordering, but at least for me it only worked with 'primitives' (Javascript does not have primitives), so I wanted something more OO style and I have created an Ordering 'interface' where you only have to implement 'compare' like you do in Java or even in Scala. I saw in some place that we can override operators and in a future version I'm planning to override >=, <= and of course == (===) (if it is really possible).

```coffeescript
class Person extends Ordering then constructor: (name, surname) ->
  @compare = (x) -> x instanceOf Person and x.name == name and x.surname == surname

p = new Person('Kleber', 'Stender')
p1 = new Person('Julio', 'Iglesias')

console.log p.equals p1 # print false
```

## Unit
In functional paradigm we can not create void functions because in it's essence, functions must always return something. Just remember you Math classes:

```
  f x = x + 1 <- It clearly returns something, sometimes does not matter what it is
```

And for this reason it has an unit object (always represented by ()) that substitutes void, returning a symbolic value when our function should returns nothing. This way we can keep function composition and a have a lot of benefits packaged with the simple act of returning something:

```coffeescript
log = (txt) -> 
  console.log txt
  unit()
  
add = (a) -> a + 1

(add.andThen log) 4 # Will print 5 (duh!) <- sorry for the worst example possible
```

# Typeclasses

Typeclasses are the fundamental principle in functional paradigm. It is a set of 'traits' (something like an abstract class) that abstracts all the base tools for you to work as much 'functional' as possible. There are a series of typeclasses but my knowledge only allowed me to bring 3 of them (even though I admit it, I only understand for sure 2 of them): Functors, Applicatives and Monads.

## Functors
Functional programming is a type of paradigm based on Mathematics, and at it's core, Mathematics is only 'map values from a value to another value', 'from a Type to another Type or the same Type'. 'What do you mean?' you might be asking. Is the essence of all Math functions to get one value as an input and transform it to another value right?

```math
  f x = x + 1 # or
  g x = x / 2
```
If we could apply types we probably would see something like this:

```math
  f::Int -> Int # It means, a fn that receives and returns an Int
  f x = x + 1 # or
  g::Int -> Double
  g x = x / 2 # (by the way, it's haskell syntax)
```
It is the base of mathematical functions, so with this in mind and bringing it to IT we can say that everything is mappable and every action we do in our application is mapping one request to a response, so we finally met Functors: 

```coffeesscript
  class Functor
    fmap: (fn) -> throw Error "(Functor::fmap) No implementation"
```
I called it fmap because it is a 'functor map'. But what can we do with it? A fmap (or map) function is a function whose have one parameter, a function from A to B , where A and B are two types that can be equal or not. But what does it mean for sure? To give you something to simplify your understanding, an array is a Functor. So imagine you have a Array of integers, lets give it a type Array[Int] (Int will be our A) and you want to transform it in a arrays of doubles multiplying it by 0.5 (now Double is our B), so you want to map an Array[Int] to an Array[B]. So what do you do right now?

```javascript
var a = [1, 2, 3, 4, 5];
b = []

for(var i in a){
  b.push(i * 0.5);
}
```

Even if you use coffeescript you have that void call to b.push. So if Javascript arrays have implemented functors fmap function (And I know it is like that today, you have [1, 2].map, but pretend it is not because it has a different implementation) you would write this way:

```coffeescript
a = [1..5].map (i) ->  i * 0.5
```

Much simpler right?

## Applicative

```coffeescript
class Applicative extends Functor
  afmap: (functor) -> throw Error "(Applicative::afmap) No implementation"
```
Imagine you want to bring the lazynes to a next level and instead of creating an array of Integers you want to create an array of functions that maps Integers to Doubles (Array[Int -> Double])? How to apply data to it and get it's value? 

```coffeescript
[((x) -> x+1.0), ((x) ->x*1.2), ((x) ->x/3.0)].fmap (x) -> x 3 # <- x here is a function
# so it is like you are applying 3 to all functions
# It will return [4.0, 3.6, 1.0]
```

But what if I have another array and whatn to apply it's values to the first array functions? Using applicative function afmap (applicative functor map) you can do it
```coffeescript
a = [((x) -> x+1.0), ((x) ->x*1.2), ((x) ->x/3.0)]
b = [1, 2, 3]
c = b.afmap b
# C = [1.0, 1.2, 0.33333, 2.0, 2.4, 0.6666, 3.0, 3.6, 1.0]
# And yes, it applies all items in b array to all functions in a array
# Or you could simply write 
d = [((x) -> x+1.0), ((x) ->x*1.2), ((x) ->x/3.0)].afmap [1, 2, 3]
```
It is useful to evaluate values on demand and lift a large ammout of functions (of course there is more usability in it, but my knowledge only allows me to understand few things about this, Applicative is the typeclass I less understand)

## Monad

~~A monad is just a monoid in the category of endofunctors~~ And here we have the most hard to understand principle of functional paradigm. Monads are the set of structures most generics in the functional World. It can help you get rid of those voids you are used to:

```coffeescript
class Monad extends Applicative
  identity: (a) -> a
  flatMap: (fn) -> throw Error "(Monad::flatMap) No implementation"
```

Actually to simplify this flatMap I think of it as a concatenator of objects. In applicatives we saw how to apply two "kinds" of functors right? One is a simple array of integers and the other an array of functions, and using afmap we lift this in a single array of 3 times it's length. So now imagine you have two "normal" arrays: [1, 2, 3] and [1, 2, 3] and you want to join them using an adding how would you do it?

```coffeescript
a = [1, 2, 3].map (x) -> [1, 2, 3].map (y) -> x + y
```

Well it would return [[2, 3, 4], [3, 4, 5], [4, 5, 6]], and I think it is not what you expected right? So what you wanted was [2, 3, 4, 3, 4, 5, 4, 5, 6]. How to achieve this? With flatMap like the name says, it will flat your response. The flatMap signature is:

```scala
def flatMap(fn: A => Monad[B]): Monad[B]
```
It means, you flatMap function expects you to return another Monad in it's callback

```coffeescript
[1, 2, 3].flatMap (x) -> [x * 2] # is the same as
[1, 2, 3].map (x) -> x * 2
```

So what is the reason to use it if I will have to use object constructors? It is better used combined with map
```coffeescript
b = [1, 2, 3].flatMap (x) -> [1, 2, 3].map (y) -> x + y
# Is the same as
c = [1, 2, 3].flatMap (x) -> [1, 2, 3].flatMap (y) -> [x + y]
```

We use map as a constructor for us making it more readable ^^

As you can see, Monad extends Applicative who understands Functor, so a Monad is a Functor and an Applicative too. And I think you might get too that an Array is a Monad.

# Container/Box theory
How can you define a function that might fail? Depends on the language right? Pretend you will have taken a task only it's only purpose is to write a div function in C and in Java. Using all the languages 'power' you probably would write somethins like:

```c
double div(int a, int b){
  if(b == 0){
    return 0.0; # Because no division can return 0, it only gets near of it
  } else {
    return a / b;
  }
}
```

```Java
public double div(int a, int b) throws Exception{
  if(b == 0){
    throw new Exception("Nothing can be divided by 0");
  } else {
    return a */ b;
  }
}
```

With java it is simple to infer that this function might fail, but the C version is hard to reason about it. You will have to add a comment and hope someone read it, and even if the developer reads it, he will have to add a protection to prevent failures in case 0.0 is returned, and in Java a try/catch will be needed. But according to the functional paradigm try/catch is 'bad', because it forces you to ignores the real problem. Ok I have invented it, but the real explanation is almost like that. So how to deal with possible failures and keep the code clean forcing the developer who will use it to work correctly? Functional paradigm brings to us the concept of container or boxes if you rather. It is a concept that uses a structure where it might or not have a value. Imagine an array. it is a box which might contain 0 or N values right? Now imagine an array with only can carry 0 or 1 value. Now check the next section.

## Maybe / Option

Maybe and Options are the same conecpt, but Maybe is the name Haskell language developer gave to it and Option is the name Scala developers for this. So I will only call it Maybe, but if you came from Scala, or if you some day go to Scala, know that you already know something about her (the language please).

```Scala
 //Scala version
 def div(a: Int, b: Int): Option[Doube] = if(b == 0) None else Some(a / b)
```
And ...

```coffeescript
 div = (a, b) -> if(b == 0) then nothing() else just a / b
```

Ok, besides the less lines code, it has more benefits. Boxes are Monads, so they have fmap and flatMap functions. Oh I forgot, did not explain what these functions does. Ok lets remember what fmap does. A fmap comes from the Functor typeclass and it is a function that gets another function as a parameter, a function that maps A into B. So we have a function named div who get two Int values and returns a possible Double, a Maybe double. But we don't know if there is a double in there or not, so how we deal with it? If we want to apply a function who process this possible double and returns for example a String saying the value, we can use map for it:

```coffee
 div(4, 2).fmap (x) -> "The result of 4 / 2 is = {x}"
```
