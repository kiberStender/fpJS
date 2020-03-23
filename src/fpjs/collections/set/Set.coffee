import Traversable from "collections/Traversable.coffee"
import {nothing, just} from "maybe/Maybe.coffee"
import {lazy} from "utils/lazy.coffee"

class Set extends Traversable
  prefix: -> "Set"
  empty: -> emptySet()
  toStringFrmt: (acc) -> (item) -> if acc is "" then item else "#{acc}, #{item}"
    
  add: (el) -> new ValSet el, @
    
  #Haskell : function or Scala :: method
  cons: (el) -> if @isEmpty() then @add el
  else switch el.compare @head()
    when 1 then @tail().cons(el).add @head()
    when 0 then (if el.equals @head() then @ else @tail().cons el)
    else @tail().add(@head()).add el

  reverse: -> @foldLeft(@empty()) (acc) -> (item) -> acc.cons item

  #Haskell and Scala ++ function
  concat: (prefix) ->
    helper = (acc) -> (other) -> if other.isEmpty() then acc
    else (helper acc.cons other.head()) other.tail()

    (helper @) prefix
      
  splitAt: (el) ->
    splitR = (n) -> (cur) -> (pre) -> if cur.isEmpty() then [pre, emptySet()]
    else if n is 0 then [pre, cur]
    else (((splitR n - 1) cur.tail()) pre.cons cur.head())
      
    (((splitR el) @) @empty())
      
  #Method that transforms a Seq of Seq's in a single Seq
  flatten: ->  if @head() instanceof ValSet
    (@foldRight @empty()) (item) -> (acc) -> acc.concat item
  else @
    
  toSeq: -> (@foldLeft seq()) (acc) -> (x) -> acc.cons x
    
class EmptySet extends Set
  isEmpty: -> true
  head: -> throw Error "No such element"
  tail: -> throw Error "No such element"
  init: -> throw Error "No such element"
  last: -> throw Error "No such element"
  maybeHead: -> nothing()
  maybeLast: -> nothing()
  headOps: -> nothing()
  equals: (x) -> x instanceof EmptySet
  
class ValSet extends Set 
  constructor: (@head_, @tail_) -> super()
  isEmpty: -> false
  head: -> @head_
  tail: -> @tail_
  init: -> @reverse().tail().reverse()
  last: -> @reverse().head()
  maybeHead: -> just @head_
  maybeLast: -> just @last_
  equals: (x) -> if x instanceof ValSet
    if @head_.equals x.head() then @tail_.equals x.tail() else false
  else false
  
emptySet = lazy -> new EmptySet()
  
set = (items...) -> if items.length is 0 then emptySet() else (arrayToSet items.slice 1).cons items[0]

arrayToSet = (arr) -> set.apply @, arr

export {Set, emptySet, set, arrayToSet}
