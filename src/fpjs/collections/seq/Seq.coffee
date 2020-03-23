import Traversable from "collections/Traversable.coffee"
import {nothing, just} from "maybe/Maybe.coffee"
import {set} from "collections/set/Set.coffee"
import {lazy} from "utils/lazy.coffee"
import "utils/ordering.coffee"

class Seq extends Traversable
  prefix: -> "Seq"
  empty: -> nil()
  toStringFrmt: (acc) -> (item) -> if acc is "" then item else "#{acc}, #{item}"
    
  #Haskell : function or Scala :: method
  cons: (el) -> new Cons el, @

  reverse: -> @foldLeft(@empty()) (acc) -> (item) -> acc.cons item

  #Haskell and Scala ++ function
  concat: (prefix) ->
    helper = (acc) -> (other) -> if other.isEmpty() then acc
    else (helper acc.cons other.head()) other.tail()

    (helper @) prefix.reverse()
      
  splitAt: (el) -> 
    splitR = (n) -> (cur) -> (pre) -> if cur.isEmpty() then [pre.reverse(), nil()]
    else if n is 0 then [pre.reverse(), cur]
    else (((splitR n - 1) cur.tail()) pre.cons cur.head())
      
    (((splitR el) @) @empty())
      
  #Method that transforms a Seq of Seq's in a single Seq
  flatten: ->  if @head() instanceof Seq
    (@foldRight @empty()) (item) -> (acc) -> acc.concat item
  else @
    
  toSet: -> (@foldLeft set()) (acc) -> (x) -> acc.cons x
    
seq = (items...) -> if items.length is 0 then nil() else (arrayToSeq items.slice 1).cons items[0]

class Cons extends Seq 
  constructor: (@head_, @tail_) -> super()
  isEmpty: -> false
  head: -> @head_
  tail: -> @tail_
  init: -> @reverse().tail().reverse()
  last: -> @reverse().head()
  maybeHead: -> just @head_
  maybeLast: -> just @last_
  equals: (x) -> if x instanceof Cons
    if @head_.equals x.head() then @tail_.equals x.tail() else false
  else false
    
class Nil extends Seq 
  isEmpty: -> true
  head: -> throw Error "No such element"
  tail: -> throw Error "No such element"
  init: -> throw Error "No such element"
  last: -> throw Error "No such element"
  maybeHead: -> nothing()
  maybeLast: -> nothing()
  headOps: -> nothing()
  equals: (x) -> x instanceof Nil

cons = (head) -> (tail) -> new Cons(head, tail)

nil = lazy -> new Nil()
  
arrayToSeq = (arr) -> seq.apply @, arr
  
export {Seq, seq, cons, nil, arrayToSeq}
