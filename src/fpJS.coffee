fpJS = do ->
  #Set of abstract classes- JS has no abstract class itself so throw error in constructor
  #is the way I found to ignore this detail
  typeclasses = do ->
    class Functor
      constructor: -> throw new Error "No direct constructor"
      fmap: (fn) -> throw new Error "No implementation"

    class Applicative extends Functor
      #Haskell <*> function
      afmap: (fn) -> throw new Error "No implementation"

    class Monad extends Applicative
      #Haskell >>= function
      bind: (fn) -> throw new Error "No implementation"
    {Functor, Applicative, Monad}

  maybe = do ->
    {Monad} = typeclasses

    class Maybe extends Monad
      fmap: (fn) -> if @ instanceof Nothing then @ else new Just fn @v
  
      afmap: (some) -> if some instanceof Nothing then @ else @fmap some.v
 
      bind: (fn) -> if @ instanceof Nothing then @ else fn @v

      getOrElse: (v) -> if @ instanceof Nothing then v else @v()

    class Just extends Maybe
      constructor: (@v) ->
      toString: -> "Just(#{@v})"
      get: -> @v

    class Nothing extends Maybe
      constructor: ->
      toString: -> "Nothing"
      get: -> throw new Error "Nothing.get"

    {Maybe, Just, Nothing}

  collections = do ->
    {Monad} = typeclasses
    {Just, Nothing} = maybe
    seq = do ->
      class Seq  extends Monad
        #toStrig method
        toString: -> "Seq(#{@foldRight("") (item, acc) -> if acc is "" then item else "#{item}, #{acc}"})"
        
        #Sugar method for creating sequences easily
        @apply: (items...) -> if items.length is 0 then new Nil
        else (new Cons items[0], Seq.apply.apply @, items.slice 1)

        #Haskell : function or Scala :: method
        append: (el) -> new Cons el, @

        #Method for reverse the sequence
        reverse: -> @foldLeft(Seq.apply()) (acc, item) -> acc.append item

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
        filter: (p) -> @foldLeft(Seq.apply()) (acc, item) -> if p item then acc.append item else acc

        #Method for findind an item inside de sequence
        find: (p) -> if @ instanceof Nil then new Nothing else if p @head then new Just @head else @tail.find p

        #Method for transforming the sequence of type A in a sequence in type B
        fmap: (fn) -> @foldRight(Seq.apply()) (item, acc) -> acc.append fn item

        #Haskell <*> function for mapping a sequence of functions and a sequence of simple data
        afmap: (listfn) -> listfn.bind (f) => @fmap f

        #Haskell >>= or Scala flatMap
        bind: (fn) -> if @ instanceof Nil then @ else @tail.bind(fn).concat(fn @head)

      class Cons extends Seq
        constructor: (@head, @tail) ->
        length: -> 1 + @tail.length()
        headOps: -> new Just @head

      class Nil extends Seq
        constructor: ->
        length: -> 0
        headOps: -> new Nothing
      {Seq, Cons, Nil}
    {seq}

  utils = do ->
    either = do ->
      class Either
        constructor: -> throw new Error "No direct constructor"
        fold: (rfn, lfn) -> if @ instanceof Right then rfn @value else lfn @value
        
      class Right extends Either 
        constructor: (@value) ->
        toString: -> "Right(#{@value})"

      class Left extends Either
        constructor: (@value) ->
        toString: -> "Left(#{@value})"

      {Either, Right, Left}
    
    try_ = do ->
      {Monad} = typeclasses

      class Try extends Monad
        constructor: -> throw new Error "No direct constructor"
        @apply: (fn) -> try new Success fn() catch e then new Failure e

      class Success extends Try
        constructor: (@value) ->
        bind: (f) -> try f @value catch e then new Failure e
        fmap: (fn) -> Try.apply => fn @value
        getOrElse: (v) -> @value
        toString: -> "Success(#{@value})"

      class Failure extends Try
        constructor: (@exception) ->
        bind: (f) -> @
        fmap: (fn) -> @
        getOrElse: (v) -> v()
        toString: -> "Failure(#{@exception})"
      {Try, Success, Failure}

    {either, try_}
  {typeclasses, maybe, collections, utils}
