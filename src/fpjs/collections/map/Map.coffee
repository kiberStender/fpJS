import Traversable from "collections/Traversable.coffee"
import {nothing, just} from "maybe/Maybe.coffee"
import {lazy} from "utils/lazy.coffee"
import "utils/ordering.coffee"

class Map extends Traversable
  prefix: -> "Map"
  empty: -> emptyMap()
  toStringFrmt: (acc) -> ([k, v]) -> if acc is "" then "(#{k} -> #{v})" else "#{acc}, (#{k} -> #{v})"

  add: (x) -> new KVMap x, @
    
  cons: (x) -> if @isEmpty() then @add x
  else switch x[0].compare @head()[0]
    when 1 then @tail().cons(x).add @head()
    when 0 then (if x[1].equals @head()[1] then @ else @tail().cons x)
    else @tail().add(@head()).add x
      
  concat: (prefix) ->
    helper = (l1) -> (l2) -> if l2.isEmpty() then l1
    else if l1.isEmpty() then l2
    else (helper l1.cons l2.head()) l2.tail()
    helper(@) prefix
      
  get: (k) -> 
    n = @length()
      
    if n is 0 then nothing()
    else if n is 1
      if @head()[0].equals k then just @head()[1] else nothing()
    else
      [x, y] = @splitAt Math.round n / 2
      if (y.head()[0].compare k) > 0 then x.get k else y.get k

  getV: (k) -> (@get k).getOrElse -> throw Error "No such element"
    
  splitAt: (el) -> 
    splitR = (n) -> (cur) -> (pre) -> if cur.isEmpty() then [pre, emptyMap()]
    else if n is 0 then [pre, cur]
    else (((splitR n - 1) cur.tail()) pre.cons cur.head())
      
    (((splitR el) @) @empty())
    
class KVMap extends Map
  constructor: (@head_, @tail_) -> super()
  isEmpty: -> false
  head: -> @head_
  tail: -> @tail_
  init: -> if @tail_.isEmpty() then @empty() else @tail_.init().cons @head_
  last: -> if @tail_.isEmpty() then @head_ else @tail_.last()
  maybeHead: -> new Just @head_
  maybeLast: -> new Just @last_
  equals: (x) -> if x instanceof KVMap
    if @head_.equals x.head() then @tail_.equals x.tail() else false
  else false
 
class EmptyMap extends Map
  isEmpty: -> true
  head: -> throw Error "No such element"
  tail: -> throw Error "No such element"
  init: -> throw Error "No such element"
  last: -> throw Error "No such element"
  maybeHead: -> nothing()
  maybeLast: -> nothing()
  headOps: -> nothing()
  equals: (x) -> x instanceof EmptyMap

emptyMap = lazy -> new EmptyMap()

map = (items...) -> 
  helper = (its) -> if its.length is 0 then emptyMap() else (helper its.slice 1).cons its[0]
  helper items.reverse()
  
export {emptyMap, map}
