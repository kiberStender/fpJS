fpJS = do ->
  typeclasses = {
    Functor: (class Functor
      constructor: -> throw new Error "No direct constructor"
      fmap: (fn) -> throw new Error "No implementation")

    Applicative: (class Applicative extends Functor
      afmap: (fn) -> throw new Error "No implementation")

    Monad: (class Monad extends Applicative
      bind: (fn) -> throw new Error "No implementation")
  }

  maybe = {
    Maybe: class Maybe extends Monad
      fmap: (fn) -> if @ instanceof Nothing then @ else new Just fn @v
  
      afmap: (some) -> if some instanceof Nothing then @ else @fmap some.v
 
      bind: (fn) -> if @ instanceof Nothing then @ else fn @v

      getOrElse: (v) -> if @ instanceof Nothing then v else @v

    Just: class Just extends Maybe
      constructor: (@v) ->
      toString: -> "Just(#{@v})"
      get: -> @v

    Nothing: class Nothing extends Maybe
      constructor: ->
      toString: -> "Nothing"
      get: -> throw new Error "Nothing.get"
  }

  collections = {
    seq: {
      Seq: class Seq  extends Monad
        toString: -> "Seq(#{@foldRight("") (item, acc) -> if acc is "" then item else "#{item}, #{acc}"})"
        @apply: (items...) -> if items.length is 0 then new Nil
        else (new Cons items[0], Seq.apply.apply this, items.slice 1)

        append: (el) -> new Cons el, @

        reverse: -> @foldLeft(Seq.apply()) (acc, item) -> new Cons item, acc

        foldLeft: (acc) -> (fn) => if @ instanceof Nil then acc
        else (@tail.foldLeft fn acc, @head) fn

        foldRight: (ac) -> (fn) => @reverse().foldLeft(ac) (acc, item) -> fn item, acc

        concat: (list) ->
          helper = (l1) -> (l2) -> if l2 instanceof Nil then l1
          else if l1 instanceof Nil then l2
          else (helper l1.append l2.head) l2.tail
    
          (helper list) @reverse()
  
        fmap: (fn) -> @foldRight(Seq.apply()) (item, acc) -> new Cons (fn item), acc

        afmap: (listfn) -> listfn.bind (f) => @fmap f

        bind: (fn) -> if @ instanceof Nil then @ else @tail.bind(fn).concat(fn @head)

      Cons: class Cons extends Seq
        constructor: (@head, @tail) ->
        headOps: -> new Just @head

      Nil: class Nil extends Seq
        constructor: ->
        headOps: -> new Nothing
    }
  }

  {typeclasses, maybe, collections}
