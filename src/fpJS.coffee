fpJS = do ->
  #Adding Ordering to all objects and instances of native JS
  Object::equals = (o) -> @toString() is o.toString()
  Object::compare = (x) -> throw new Error "No implementation"
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
    constructor: -> throw new Error "No direct constructor"
    toString: -> "#{@}"
    hashCode: -> 13
    equals: (x) -> x instanceof Any and @hashCode() is x.hashCode()
    
  class Ordering extends Any
    compare: (x) -> throw new Error "No implementation"
    lessThan: (x) -> (@compare x) is -1
    greaterThan: (x) -> (@compare x) is 1

  class Functor extends Any
    #method to map the internal data of type A into a data of type B
    fmap: (fn) -> throw new Error "No implementation"

  class Applicative extends Functor
    #Haskell <*> function
    afmap: (fn) -> throw new Error "No implementation"

  class Monad extends Applicative
    #Haskell >>= function
    bind: (fn) -> throw new Error "No implementation"

  class Maybe extends Monad
    fmap: (fn) -> if @ instanceof Nothing then @ else new Just fn @v
    afmap: (some) -> if some instanceof Nothing then @ else @fmap some.v
    bind: (fn) -> if @ instanceof Nothing then @ else fn @v
    getOrElse: (v) -> if @ instanceof Nothing then v() else @v

  class Just extends Maybe
    constructor: (@v) ->
    toString: -> "Just(#{@v})"
    get: -> @v
    equals: (x) -> if x instanceof Just
      if typeof @v isnt "object" and typeof v isnt "object"
        @v is x.v
      else if typeof @v is "object" and typeof x is "object" and x.equals then x.equals @v else false
    else false

  nothing = new class Nothing extends Maybe
    constructor: ->
    toString: -> "Nothing"
    get: -> throw new Error "Nothing.get"
    equals: (x) -> x instanceof Nothing
    
  class Seq  extends Monad
    #toStrig method
    toString: -> "Seq(#{@foldRight("") (item, acc) -> if acc is "" then item else "#{item}, #{acc}"})"

    #Sugar method for creating sequences easily
    @apply: (items...) -> if items.length is 0 then nil else (new Cons items[0], Seq.apply.apply @, items.slice 1)

    #Haskell : function or Scala :: method
    append: (el) -> new Cons el, @

    #Method for reverse the sequence
    reverse: -> @foldLeft(seq()) (acc, item) -> acc.append item

    #Method for folding the sequence in the left side
    foldLeft: (acc) -> (fn) => if @ instanceof Nil then acc else (@tail.foldLeft fn acc, @head) fn

    #Method for folding the sequence in the right side
    foldRight: (ac) -> (fn) => @reverse().foldLeft(ac) (acc, item) -> fn item, acc

    #Haskell and Scala ++ function
    concat: (list) ->
      helper = (l1) -> (l2) -> if l2 instanceof Nil then l1
      else if l1 instanceof Nil then l2
      else (helper l1.append l2.head) l2.tail

      (helper list) @reverse()

    #Method for filtering the sequence
    filter: (p) -> @foldLeft(seq()) (acc, item) -> if p item then acc.append item else acc

    #Method for findind an item inside de sequence
    find: (p) -> if @ instanceof Nil then nothing else if p @head then new Just @head else @tail.find p
    
    #Method that transforms a Seq of Seq's in a single Seq
    flatten: ->  if @head instanceof Seq
      (@foldLeft seq()) (acc, item) -> acc.concat item 
    else @

    #Method for transforming the sequence of type A in a sequence in type B
    fmap: (fn) -> @foldRight(seq()) (item, acc) -> acc.append fn item

    #Haskell <*> function for mapping a sequence of functions and a sequence of simple data
    afmap: (listfn) -> listfn.bind (f) => @fmap f

    #Haskell >>= or Scala flatMap
    bind: (fn) -> (@fmap fn).flatten()
    
  seq = Seq.apply
  
  arrayToSeq = (arr) -> if arr instanceof Array
    helper =  (head) -> (tail) -> if head instanceof Array
      (helper head[0]) head.slice 1
    else if tail.length is 0 then seq head
    else ((helper tail[0]) tail.slice 1).append head
      
    if arr.length is 0 then seq()
    else
      if arr[0] instanceof Array then (arrayToSeq arr.slice 1).append (helper arr[0][0]) arr[0].slice 1
      else (arrayToSeq arr.slice 1).append arr[0]
  else throw new Error "Not an Array"

  class Cons extends Seq
    constructor: (@head, @tail) ->
    length: -> 1 + @tail.length()
    headOps: -> new Just @head
    equals: (x) -> if x instanceof Cons
      if typeof @head isnt "object" and typeof x.head isnt "object" #x is a Cons instance, it should test head not x itself
        if @head is x.head
          if @tail instanceof Nil and x.tail instanceof Nil then true 
          else if @tail instanceof Cons and x.tail instanceof Cons then @tail.equals x.tail
          else false
        else false
      else if typeof @head is "object" and typeof x is "object" and x.equals
        x.equals @head 
      else false
    else false

  nil = new class Nil extends Seq
    constructor: ->
    length: -> 0
    headOps: -> nothing
    equals: (x) -> x instanceof Nil
    
  #seq.Tree
  class Tree extends Any

  emptyBranch = new class EmptyBranch extends Tree
    constructor: ->
    toString: -> ""
    include: (x) -> (f) -> new Branch emptyBranch, x, emptyBranch

  class Branch extends Tree
    constructor: (@left, @value, @right) ->
    toString: -> "{#{@left} #{@value} #{@right}}"
    include: (x) -> (f) => if (f x, @value) < 0 then new Branch ((@left.include x) f), @value, @right
    else if (f x, @value) > 0 then new Branch @left, @value, (@right.include x) f
    else @
    
  #Range
  class Range extends Any
    constructor: (@start, @end, @step = 1) ->
    to: -> if @start >= @end then nil else new Cons @start, (new Range (@start+@step), @end, @step).to()
    
  class Either extends Any 
    fold: (rfn, lfn) -> if @ instanceof Right then rfn @value else lfn @value

  class Right extends Either 
    constructor: (@value) ->
    toString: -> "Right(#{@value})"

  class Left extends Either
    constructor: (@value) ->
    toString: -> "Left(#{@value})"    

  class Try extends Monad
    @apply: (fn) -> try new Success fn() catch e then new Failure e
    
  #syntax sugar for Try.apply
  _try = Try.apply

  class Success extends Try
    constructor: (@value) ->
    bind: (f) -> try f @value catch e then new Failure e
    fmap: (fn) -> _try => fn @value
    getOrElse: (v) -> @value
    toString: -> "Success(#{@value})"

  class Failure extends Try
    constructor: (@exception) ->
    bind: (f) -> @
    fmap: (fn) -> @
    getOrElse: (v) -> v()
    toString: -> "Failure(#{@exception})"

  {
    #typeclases
    Functor, Applicative, Monad
    #maybe
    Just, nothing
    #collections.seq
    seq, Cons, nil, arrayToSeq
    #collections.tree
    emptyBranch, Branch
    #collections.range
    Range
    #utils.either
    Right, Left
    #utils.try_
    _try, Success, Failure
  }

root = exports ? window
root.fpJS = fpJS
