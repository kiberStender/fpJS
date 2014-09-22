fpJS = do ->
  notInstance = null
  mapInstance = null
  nilInstance = null
  emptyTreeInstance = null
  
  #Adding Ordering to all objects and instances of native JS
  Object::equals = (o) -> @toString() is o.toString()
  Object::compare = (x) -> throw Error "No implementation"
  Object::lessThan = (x) -> (@compare x) is -1
  Object::greaterThan = (x) -> (@compare x) is 1
  
  #Adding Ordering to Native JS objects
  Number::compare = (x) -> if typeof x is "number"
    if (@ + 0) is x then 0 else if (@ + 0) < x then -1 else 1
  else -2
  
  String::compare = (s) -> if typeof s is "string" 
    if (@ + "").length is s.length then 0 else if (@ + "").length < s.length then -1 else 1
  else -2
  
  #Set of abstract classes- JS has no abstract class itself so throw error in constructor is the way I found to ignore this detail
  class Any
    constructor: -> throw Error "No direct constructor"
    toString: -> "#{@}"
    hashCode: -> 13
    equals: (x) -> x instanceof Any and @hashCode() is x.hashCode()
    
  class Ordering extends Any
    compare: (x) -> throw Error "No implementation"
    lessThan: (x) -> (@compare x) is -1
    greaterThan: (x) -> (@compare x) is 1

  class Functor extends Any
    #method to map the internal data of type A into a data of type B
    fmap: (fn) -> throw Error "No implementation"

  class Joinable extends Functor
    join: -> throw Error "No implementation"

  class Applicative extends Joinable
    #Haskell <*> function
    afmap: (fn) -> throw Error "No implementation"

  class Monad extends Applicative
    #Haskell >>= function
    flatMap: (fn) -> @fmap(fn).join()

  class Maybe extends Monad
    fmap: (fn) -> if @ instanceof Nothing then @ else new Just fn @v()
    afmap: (some) -> if some instanceof Nothing then @ else @fmap some.v()
    getOrElse: (v) -> if @ instanceof Nothing then v() else @v()

  class Just extends Maybe then constructor: (v) ->
    @v = -> v  
    @toString = -> "Just(#{v})"
    @get = -> v
    @join = -> v
    @equals = (x) -> if x instanceof Just then v.equals x.v() else false
    
  class Nothing extends Maybe then constructor: ->
    @toString = -> "Nothing"
    @get = -> throw new Error "Nothing.get"
    @join = -> @
    @equals = (x) -> x instanceof Nothing

  nothing = -> if notInstance is null
    notInstance = new Nothing()
    notInstance
  else notInstance

  class Traversable extends Monad
    isEmpty: -> throw Error "Not implemented yet!!!"
    
    head: -> throw Error "Not implemented yet!!!"
    
    tail: -> throw Error "Not implemented yet!!!"
    
    init: -> throw Error "Not implemented yet!!!"
    
    last: -> throw Error "Not implemented yet!!!"
    
    maybeHead: -> throw Error "Not implemented yet!!!"
    
    maybeLast: -> throw Error "Not implemented yet!!!"
    
    empty: -> throw Error "Not implemented yet!!!"
    
    ###
     Scala :: and Haskell : functions
     @param item the item to be appended to the collection
     @return a new collection
    ###
    cons: (item) -> throw Error "Not implemented yet!!!"
    
    ###
     Scala and Haskell ++ function
     @param prefix new collection to be concat in the end of this collection
     @return a new collection
    ###
    concat: (tr) -> throw Error "Not implemented yet!!!"
    
    toString: -> """#{@prefix()}(#{@foldLeft("") @toStringFrmt})"""
    
    prefix: -> throw Error "Not implemented yet!!!"
    
    toStringFrmt: (acc) -> (item) -> throw Error "Not implemented yet!!!"
    
    length: -> @foldLeft(0) (acc) -> (item) -> acc + 1
    
    #Method for filtering the sequence
    filter: (p) -> throw Error "Not implemented yet!!!"
    
    filterNot: (p) -> @filter (x) -> !p x
    
    partition: (p) -> [(@filter p), @filterNot p]
    
    find: (p) -> if @isEmpty() then nothing() else (if p @head() then new Just @head() else @tail().find p)
    
    splitAt: (n) -> throw Error "Not implemented yet!!!"
    
    #Method for folding the sequence in the left side
    foldLeft: (acc) -> (f) => if @isEmpty() then acc else @tail().foldLeft(f(acc) @head()) f

    #Method for folding the sequence in the right side
    foldRight: (acc) -> (fn) => if @isEmpty() then acc else fn(@head())(@tail().foldRight(acc) fn)
    
    fmap: (f) -> @foldRight(@empty())((item) -> (acc) -> acc.cons f item)

  class Map extends Traversable
    prefix: -> "Map"
    empty: -> emptyMap()
    toStringFrmt: (acc) -> (item) -> 
      [k, v] = item
      if acc is "" then "(#{k} -> #{v})" else "#{acc}, (#{k} -> #{v})"

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
      
    get: (k) -> (@find (x) -> x[0].equals k).fmap (x) -> x[1]
      
    filter: (p) -> @foldRight(@empty()) (item) -> (acc) -> if p item then acc.cons item else acc

    getV: (k) -> (@get k).getOrElse -> throw Error "No such element"
    
    splitAt: (el) -> 
      splitR = (n) -> (cur) -> (pre) -> if cur.isEmpty() then [pre, emptyMap()]
      else if n is 0 then [pre, cur]
      else (((splitR n - 1) cur.tail()) pre.cons cur.head())
      
      (((splitR el) @) @empty())
    
  class KVMap extends Map then constructor: (head, tail) ->
    @isEmpty = -> false
    @head = -> head
    @tail = -> tail
    @equals = (x) -> if x instanceof KVMap
      if head.equals x.head() then tail.equals x.tail() else false
    else false
  
  class EmptyMap extends Map then constructor: ->
    @isEmpty = -> true
    equals: (x) -> x instanceof EmptyMap

  emptyMap = -> if mapInstance is null
    mapInstance = new EmptyMap()
    mapInstance
  else mapInstance

  map = (items...) -> if items.length is 0 then emptyMap() else (map.apply @, items.slice 1).cons items[0]
    
  class Seq  extends Traversable
    prefix: -> "Seq"
    empty: -> nil()
    toStringFrmt: (acc) -> (item) -> if acc is "" then item else "#{acc}, #{item}"
    
    #Haskell : function or Scala :: method
    cons: (el) -> new Cons el, @

    reverse: -> @foldLeft(seq()) (acc) -> (item) -> acc.cons item

    #Haskell and Scala ++ function
    concat: (list) ->
      helper = (l1) -> (l2) -> if l2.isEmpty() then l1
      else if l1.isEmpty() then l2
      else (helper l1.cons l2.head()) l2.tail()

      (helper list) @reverse()
      
    splitAt: (el) -> 
      splitR = (n) -> (cur) -> (pre) -> if cur.isEmpty() then [pre.reverse(), nil()]
      else if n is 0 then [pre.reverse(), cur]
      else (((splitR n - 1) cur.tail()) pre.cons cur.head())
      
      (((splitR el) @) nil())

    #Method for filtering the sequence
    filter: (p) -> @foldLeft(seq()) (acc) -> (item) -> if p item then acc.cons item else acc
    
    #Method that transforms a Seq of Seq's in a single Seq
    flatten: ->  if @head() instanceof Seq
      (@foldLeft seq()) (acc) -> (item) -> acc.concat item
    else @

    join: -> @flatten()

    #Haskell <*> function for mapping a sequence of functions and a sequence of simple data
    afmap: (listfn) -> listfn.flatMap (f) => @fmap f
    
  seq = (items...) -> if items.length is 0 then nil() else (new Cons items[0], seq.apply @, items.slice 1)
  
  arrayToSeq = (arr) -> if arr instanceof Array
    helper =  (head) -> (tail) -> if head instanceof Array
      (helper head[0]) head.slice 1
    else if tail.length is 0 then seq head
    else ((helper tail[0]) tail.slice 1).cons head
      
    if arr.length is 0 then seq()
    else
      if arr[0] instanceof Array then (arrayToSeq arr.slice 1).cons (helper arr[0][0]) arr[0].slice 1
      else (arrayToSeq arr.slice 1).cons arr[0]
  else throw new Error "Not an Array"

  class Cons extends Seq then constructor: (head, tail) ->
    @isEmpty = -> false
    @head = -> head
    @tail = -> tail
    @init = -> @reverse().tail().reverse()
    @last = -> @reverse().head()
    @maybeHead = -> new Just head
    @maybeLast = -> new Just last()
    @equals = (x) -> if x instanceof Cons
      if head.equals x.head() then tail.equals x.tail() else false
    else false
    
  class Nil extends Seq
    constructor: ->
    isEmpty: -> true
    head : -> throw Error "No such element"
    tail: -> throw Error "No such element"
    init: -> throw Error "No such element"
    last: -> throw Error "No such element"
    maybeHead: -> nothing()
    maybeLast: -> nothing()
    headOps: -> nothing()
    equals: (x) -> x instanceof Nil

  nil = -> if nilInstance is null
    nilInstance = new Nil()
    nilInstance
  else nilInstance
    
  #seq.Tree
  class Tree extends Any

  class EmptyBranch extends Tree
    constructor: ->
    toString: -> ""
    equals: (t) -> t instanceof EmptyBranch
    include: (x) -> new Branch emptyBranch, x, emptyBranch
    
  emptyBranch = -> if emptyTreeInstance is null
    emptyTreeInstance = new EmptyBranch
    emptyTreeInstance
  else emptyTreeInstance

  class Branch extends Tree then constructor: (left, value, right) ->
    @left = -> left
    @value = -> value
    @right = -> right
    
    @toString = -> "{#{left} #{value} #{right}}"
    
    @equals = (t) -> if t instanceof Branch
      if value.equals t.value() then (left.equals t.left()) && (right.equals t.right()) else false
    else false
    
    @include = (x) -> switch value.compare x
      when 1 then new Branch (left.include x), value, right
      when 0 then @
      when -1 then new Branch left, value,  right.include x
      when -2 then new Error "Type constraint problem. X[#{typeof x}] different from value[#{typeof value}]"
      
  Number::to = (end) -> new Range (@ + 0), end
  Number::until = (end) -> new Range (@ + 0), (end - 1)
      
  #Range
  class Range extends Seq then constructor: (start, end, step = 1) ->
    @head = -> start
    @tail = -> if start > end then nil() else new Range (start + step), end, step
    
    toSeq =  ->
      helper = (st) -> if st > end then nil() else new Cons st, helper st + step
      helper start
      
    @toString = -> "Range(#{start}...#{end})"
    @by = (st) -> new Range start, end, st
    
    @fmap = (fn) -> @foldLeft(seq()) (acc, item) ->
      
    #@flatMap = (fn) -> toSeq().flatMap fn
    @foldLeft = (acc) -> (fn) -> (tail().foldLeft fn acc, head()) fn
    
  class Either extends Any 
    fold: (rfn, lfn) -> if @ instanceof Right then rfn @value() else lfn @value()

  class Right extends Either then constructor: (value) ->
    @value = -> value
    @toString = -> "Right(#{value})"

  class Left extends Either then constructor: (value) ->
    @value = -> value
    toString: -> "Left(#{value})"    

  class Try extends Monad
    @apply: (fn) -> try new Success fn() catch e then new Failure e
    
  #syntax sugar for Try.apply
  _try = Try.apply

  class Success extends Try then constructor: (value) ->
    @flatMap = (f) -> try f value catch e then new Failure e
    @fmap = (fn) -> _try -> fn value
    @getOrElse = (v) -> value
    @toString = -> "Success(#{value})"

  class Failure extends Try then constructor: (exception) ->
    @flatMap = (f) -> @
    @fmap = (fn) -> @
    @getOrElse = (v) -> v()
    @toString = -> "Failure(#{exception})"
    
  #State Monad
  class State extends Monad
    constructor: (@run) ->
      @fmap = (f) -> new State (s) ->
        [a, t] = run s
        [(f a), t]

      @flatMap = (f) -> new State (s) ->
        [a, t] = run s
        (f a).run t

      @evaluate = (s) -> run(s)[0]

    @insert: (a) -> new State (s) -> [a, s]
    @get: (f) -> new State (s) -> [(f s), s]
    @mod: (f) -> new State (s) -> [[], f s]

  {
    #typeclases
    Functor, Applicative, Monad
    #maybe
    Just, nothing
    #coollections.map
    map
    #collections.seq
    seq, Cons, nil, arrayToSeq
    #collections.tree
    emptyBranch, Branch
    #utils.either
    Right, Left
    #utils.try_
    _try, Success, Failure
    State
  }

root = exports ? window
root.fpJS = fpJS
