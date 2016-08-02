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
Functional programming is a type of paradigm based on Mathematics, and at the core, Mathematic is only map values to a value from another value, to a Type to another Type or the same Type. 'What do you mean?' you might be asking. I the essence all Math functions get one value as a input and transform it to another value right?

```math
  f x = x + 1
```

If we could apply types we probably would see this:

```math
  Int -> Int # It means, a fn that receives and returns an Int (by the way, it's haskell syntax)
  f x = x + 1
```
It is the base of mathematical function, so with this in mind and bringing it to IT we can say that everything is mappable, so we finally met Functors

```coffeesscript
  class Functor
    fmap: (fn) -> throw Error "(Functor::fmap) No implementation"
```

I called it fmap because it is a 'functor map'. But we can do with it? For now nothing, but wait for it, you will like it.

## Applicative
This is the typeclass I less understand, I can say I did not understand id very well. So If I did not understand why do I added this in my 'framework'? Because the example I saw made sense, I just don't know how to apply it to others examples. So for now I won't explain this, but I will let it here so if someone understands and want to explain me, I will be glad ^^.

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
