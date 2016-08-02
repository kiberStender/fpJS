fpJS
====

Portugês

Biblioteca Javascript funcional 'scala-like' feita em Coffeescript

=====================================================================================
English

A functional programming Scala-like lib for Javascript projects made in CoffeeScript

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
