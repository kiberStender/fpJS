import Monad from "typeclass/monad/Monad.coffee"
import {nothing, just} from "maybe/Maybe.coffee"

export default class Traversable extends Monad
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
    
  length: -> @foldLeft(0) (acc) -> (_) -> acc + 1
    
  #Method for filtering the traversable
  filter: (p) -> @foldLeft(@empty()) (acc) -> (item) -> if p item then acc.cons item else acc
    
  filterNot: (p) -> @filter (x) -> !p x
    
  partition: (p) -> [(@filter p), @filterNot p]
    
  find: (p) -> if @isEmpty() then nothing() else (if p @head() then just @head() else @tail().find p)
    
  contains: (item) -> (@find item).isDefined()
    
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
    
  toNativeArray: -> if @isEmpty() then [] else [@head()].concat @tail().toNativeArray()
