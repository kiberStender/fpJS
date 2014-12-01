fpJS = do ->
  notInstance = null
  mapInstance = null
  nilInstance = null
  emptyTreeInstance = null
  unitInstance = null
  
  #Adding Ordering to all objects and instances of native JS
  Object::equals = (o) -> @toString() is o.toString()
  Object::compare = (x) -> throw Error "(Object::compare) No implementation"
  Object::lessThan = (x) -> (@compare x) is -1
  Object::greaterThan = (x) -> (@compare x) is 1
  
  #Adding Ordering to Native JS objects
  Number::compare = (x) -> if typeof x is "number"
    if (@ + 0) is x then 0 else if (@ + 0) < x then -1 else 1
  else -2
  
  String::compare = (s) -> if typeof s is "string"
    if (@ + '') is s then 0 else if (@ + '') < s then -1 else 1
  else -2
  
  #Set of abstract classes- JS has no abstract class itself so throw error in constructor is the way I found to ignore this detail
  class Any
    constructor: -> throw Error "(Any) No direct constructor"
    toString: -> "#{@}"
    hashCode: -> 13
    equals: (x) -> x instanceof Any and @hashCode() is x.hashCode()
    
  class Ordering extends Any
    compare: (x) -> throw Error "(Ordering::compare) No implementation"
    lessThan: (x) -> (@compare x) is -1
    greaterThan: (x) -> (@compare x) is 1
    
  class Unit extends Any then constructor: ->
    @equals = (u) -> u instanceof Unit
    @toString = -> "Unit"
  
  unit = -> if not unitInstance then unitInstance = new Unit() else unitInstance

  class Functor extends Any
    #method to map the internal data of type A into a data of type B
    fmap: (fn) -> throw Error "(Functor::fmap) No implementation"

  class Applicative extends Functor
    #Haskell <*> function
    afmap: (fn) -> throw Error "(Applicative::afmap) No implementation"

  class Monad extends Applicative
    #Haskell >>= function
    flatMap: (fn) -> throw Error "(Monad::flatMap) No implementation"

  class Maybe extends Monad
    fmap: (fn) -> if @ instanceof Nothing then @ else new Just fn @get()
    afmap: (some) -> if some instanceof Nothing then @ else @fmap some.get()
    flatMap: (f) -> if @ instanceof Nothing then @ else f @get()
    getOrElse: (v) -> throw Error "(Maybe::getOrElse) No implementation"
    get: -> throw Error "(Maybe::get) No implementation"

  class Just extends Maybe then constructor: (v) ->
    @toString = -> "Just(#{v})"
    @get = -> v
    @getOrElse = (_v) -> v
    @equals = (x) -> if x instanceof Just then v.equals x.get() else false
    
  class Nothing extends Maybe then constructor: ->
    @toString = -> "Nothing"
    @get = -> throw new Error "Nothing.get"
    @getOrElse = (v) -> v()
    @equals = (x) -> x instanceof Nothing

  nothing = -> if notInstance is null
    notInstance = new Nothing()
    notInstance
  else notInstance

  class Traversable extends Monad
    isEmpty: -> throw Error "(Traversable::isEmpty) Not implemented yet!!!"
    
    head: -> throw Error "(Traversable::head) Not implemented yet!!!"
    
    tail: -> throw Error "(Traversable::tail) Not implemented yet!!!"
    
    init: -> throw Error "(Traversable::init) Not implemented yet!!!"
    
    last: -> throw Error "(Traversable::last) Not implemented yet!!!"
    
    maybeHead: -> throw Error "(Traversable::maybeHead) Not implemented yet!!!"
    
    maybeLast: -> throw Error "(Traversable::maybeLast) Not implemented yet!!!"
    
    empty: -> throw Error "(Traversable::empty) Not implemented yet!!!"
    
    ###
     Scala :: and Haskell : functions
     @param item the item to be appended to the collection
     @return a new collection
    ###
    cons: (item) -> throw Error "(Traversable::cons) Not implemented yet!!!"
    
    ###
     Scala and Haskell ++ function
     @param prefix new collection to be concat in the end of this collection
     @return a new collection
    ###
    concat: (tr) -> throw Error "(Traversable::concat) Not implemented yet!!!"
    
    toString: -> """#{@prefix()}(#{@foldLeft("") @toStringFrmt})"""
    
    prefix: -> throw Error "(Traversable::prefix) Not implemented yet!!!"
    
    toStringFrmt: (acc) -> (item) -> throw Error "(Traversable::toStringFrmt) Not implemented yet!!!"
    
    length: -> @foldLeft(0) (acc) -> (item) -> acc + 1
    
    #Method for filtering the traversable
    filter: (p) -> @foldLeft(@empty()) (acc) -> (item) -> if p item then acc.cons item else acc
    
    filterNot: (p) -> @filter (x) -> !p x
    
    partition: (p) -> [(@filter p), @filterNot p]
    
    find: (p) -> if @isEmpty() then nothing() else (if p @head() then new Just @head() else @tail().find p)
    
    contains: (item) -> (@find (x) -> item.equals x) instanceof Just
    
    splitAt: (n) -> throw Error "(Traversable::splitAt) Not implemented yet!!!"
    
    #Method for folding the sequence in the left side
    foldLeft: (acc) -> (f) => if @isEmpty() then acc else @tail().foldLeft(f(acc) @head()) f

    #Method for folding the sequence in the right side
    foldRight: (acc) -> (fn) => if @isEmpty() then acc else fn(@head())(@tail().foldRight(acc) fn)
    
    fmap: (f) -> @foldRight(@empty())((item) -> (acc) -> acc.cons f item)
    
    flatMap: (f) -> if @isEmpty() then @empty() else @tail().flatMap(f).concat f @head()

    #Haskell <*> function for mapping a sequence of functions and a Traversable of simple data
    afmap: (listfn) -> listfn.flatMap (f) => @fmap f
    
    zip: (tr) -> if @isEmpty() or tr.isEmpty() then @empty() else @tail().zip(tr.tail()).cons [@head(), tr.head()]
    
    zipWith: (tr) -> (fn) => @zip(tr).fmap fn

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
      
    get: (k) -> 
      n = @length()
      
      if n is 0 then nothing()
      else if n is 1
        if @head()[0].equals k then new Just @head()[1] else nothing()
      else
        [x, y] = @splitAt Math.round n / 2
        if (y.head()[0].compare k) > 0 then x.get k else y.get k

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
    @init = -> if tail.isEmpty() then @empty() else tail.init().cons head
    @last = -> if tail.isEmpty() then head else tail.last()
    @maybeHead = -> new Just head
    @maybeLast = -> new Just last()
    @equals = (x) -> if x instanceof KVMap
      if head.equals x.head() then tail.equals x.tail() else false
    else false
  
  class EmptyMap extends Map then constructor: ->
    @isEmpty = -> true
    @head  = -> throw Error "No such element"
    @tail = -> throw Error "No such element"
    @init = -> throw Error "No such element"
    @last = -> throw Error "No such element"
    @maybeHead = -> nothing()
    @maybeLast = -> nothing()
    @headOps = -> nothing()
    @equals = (x) -> x instanceof EmptyMap

  emptyMap = -> if mapInstance is null
    mapInstance = new EmptyMap()
    mapInstance
  else mapInstance

  map = (items...) -> 
    helper = (its) -> if its.length is 0 then emptyMap() else (helper its.slice 1).cons its[0]
    helper items.reverse()
    
  class Seq  extends Traversable
    prefix: -> "Seq"
    empty: -> nil()
    toStringFrmt: (acc) -> (item) -> if acc is "" then item else "#{acc}, #{item}"
    
    #Haskell : function or Scala :: method
    cons: (el) -> new Cons el, @

    reverse: -> @foldLeft(@empty()) (acc) -> (item) -> acc.cons item

    #Haskell and Scala ++ function
    concat: (list) ->
      helper = (l1) -> (l2) -> if l2.isEmpty() then l1
      else if l1.isEmpty() then l2
      else (helper l1.cons l2.head()) l2.tail()

      (helper @) list.reverse()
      
    splitAt: (el) -> 
      splitR = (n) -> (cur) -> (pre) -> if cur.isEmpty() then [pre.reverse(), nil()]
      else if n is 0 then [pre.reverse(), cur]
      else (((splitR n - 1) cur.tail()) pre.cons cur.head())
      
      (((splitR el) @) @empty())
      
    #Method that transforms a Seq of Seq's in a single Seq
    flatten: ->  if @head() instanceof Seq
      (@foldRight @empty()) (item) -> (acc) -> acc.concat item
    else @
    
  seq = (items...) -> if items.length is 0 then nil() else (seq.apply @, items.slice 1).cons items[0]
  
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
    
  class Nil extends Seq then constructor: ->
    @isEmpty = -> true
    @head  = -> throw Error "No such element"
    @tail = -> throw Error "No such element"
    @init = -> throw Error "No such element"
    @last = -> throw Error "No such element"
    @maybeHead = -> nothing()
    @maybeLast = -> nothing()
    @headOps = -> nothing()
    @equals = (x) -> x instanceof Nil

  nil = -> if nilInstance is null
    nilInstance = new Nil()
    nilInstance
  else nilInstance
      
  #Range
  class Range extends Seq then constructor: (start, end, step = 1) ->
    @head = -> start
    @tail = -> if @isEmpty() then nil() else new Range (start + step), end, step
    @isEmpty = -> start > end
      
    @toString = -> "Range(#{start}...#{end})"
    @by = (st) -> new Range start, end, st
    
  Number::to = (end) -> new Range (@ + 0), end
  Number::until = (end) -> new Range (@ + 0), (end - 1)
    
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
    
  class IO extends Monad then constructor: (f) ->
    @unsafePerformIO = -> f()
    @join = (action) -> new IO -> action.unsafePerformIO().unsafePerformIO()
    @fmap = (fn) -> new IO => fn @unsafePerformIO()
    @flatMap = (fn) -> @join @fmap fn
    @foreach = (io) -> @flatMap (a) -> io
    @toString = -> "IO"
    
  class FPNode then constructor: (obj) ->
    @getValue = -> new IO -> if obj instanceof HTMLInputElement then obj.value else obj.innerHTML
    
    @setValue = (vl) -> new IO -> if obj instanceof HTMLInputElement
      obj.value = vl
      unit()
    else
      obj.innerHTML = vl
      unit()
    
  IOPerformer = do ->
    ioPerform = (fn) -> (str) -> new IO ->
      fn str
      unit()
    
    consoleIO = ioPerform console.log.bind console
    alertIO = ioPerform alert
    
    queryAnalyser = (str) ->
      helper = (arr) -> if arr.length is 0 then seq() else (helper arr.slice 1).concat seq arr[0]
      
      helper str.split /(?=\W+)/g
      
    main = (fn) -> document.addEventListener "DOMContentLoaded", (event) -> fn(event).unsafePerformIO()
      
    {alertIO, consoleIO, main}
    
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
    #Unit
    unit
    #typeclases
    Functor, Applicative, Monad
    #maybe
    Nothing, Just, nothing
    #collections.map
    map
    #collections.seq
    seq, Cons, nil, arrayToSeq
    #utils.either
    Right, Left
    #utils.try_
    _try, Success, Failure
    #IO
    IO, FPNode, IOPerformer
    #State
    State
  }

root = exports ? window
root.fpJS = fpJS
