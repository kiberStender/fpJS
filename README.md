fpJS
====

## Lazy

Functional paradigm is lazy by default and it means that everythig is a function and will be evaluated only where it is needed to, but Coffeescript is not a 100% pure functional language, so I created a function named "lazy" to simulate this behaviour and to create singletons too.

```coffeescript
  a = lazy -> 10 # i makes 'a' a lazy evaluable variable which returns 10
  console.log a()  # This will print 10
  # This a limitation we have to deal. By default Scala support parenthesesless 
  # (Does this word exist?)  but coffeescript do not
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
In functional paradigm we can not create void functions because in it's essence, functions must always return something. And for this reason it has a unit object (always represented bu ()) that substitute void, returning a symbolic value when our function should return nothing. This way we can keep function composition and a have a lot of benefits packaged with the simple act of returning something

```coffeescript
log = (txt) -> 
  console.log txt
  unit()
  
add = (a) -> a + 1

(add.andThen log) 4 # Will print 5 (duh!) <- sorry for the worst example possible
```

# Typeclasses

Typeclasses are the fundamental principle in functional paradigm. It is a set of 'traits' (something like an abstract class) that abstract all the base tools for you to work as much 'functional' as possible. There are a series of typeclasses but my knowledge only allowed to bring 3 of them (even though I admit, I only understand for sure 2): Functors, Applicative and Moand

## Functors
Functional programming is a type of paradigm based on Mathematics, and at the core, Mathematics is only map values from a value to another value, from a Type to another Type or the same Type. 'What do you mean?' you might be asking. Is the essence of all Math functions to get one value as an input and transform it to another value right?

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
It is the base of mathematical functions, so with this in mind and bringing it to IT we can say that everything is mappable, so we finally met Functors: 

```coffeesscript
  class Functor
    fmap: (fn) -> throw Error "(Functor::fmap) No implementation"
```

I called it fmap because it is a 'functor map'. But what can we do with it? A fmap (or map) function is a function whose have one parameter, a function from A to B , where A and B are two types that can be equal or not. But what does it mean for sure? It means you will have a Functor of some type A, for examplea Int, and will apply to it a function that transforms this A into a B, let's say a String, so in a few words you will transform this Functor[Int] in a Functor[String], whatever the way you will do it.

## Applicative
This is the typeclass I less understand, I can say I did not understand it very well. So If I did not understand why did I add this in my 'framework'? Because the example I saw made sense, I just don't know how to apply it to others examples. So for now I won't explain this, but I will let it here so if someone understands and want to explain me, I will be glad ^^.

```coffeescript
class Applicative extends Functor
  afmap: (fn) -> throw Error "(Applicative::afmap) No implementation"
```

## Monad

And here we have the most hard to understand principle of functional paradigm. Monads are the set of structures most generics in the functional World. It can help you get rid of those voids you are used to. But like Functors I will explain it in the next section, for now I will only show its structure:

```coffeescript
class Monad extends Applicative
  identity: (a) -> a
  flatMap: (fn) -> throw Error "(Monad::flatMap) No implementation"
```

As you can see, Monad extends Applicative who understands Functor, so a Monad is a Functor. Wow. With no example it is hard to explain, but I will start the explanation here. A Monad has two more functions I thought we don't need here. One is a function coming from Applicative named 'pure'. This function serves as our 'new'. It only instantiantes our Applicative/ Monad, and the other function is a function from Monad itself named return. it has the same functionality as the pure function, that's why I did not add these two functions.

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
