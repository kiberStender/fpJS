import Monad from "typeclass/monad/Monad.coffee"
import {lazy} from "utils/lazy.coffee"

class Maybe extends Monad
  fmap: (fn) -> if not @isDefined() then nothing() else just fn @get()
  afmap: (some) -> if not some.isDefined() then nothing() else @fmap some.get()
  flatMap: (f) -> if not @isDefined() then nothing() else f @get()
  isDefined: -> throw Error "(Maybe::isDefined) No implementation"
  orElse: (v) -> throw Error "(Maybe::orElse) No implementation"
  getOrElse: (v) -> throw Error "(Maybe::getOrElse) No implementation"
  get: -> throw Error "(Maybe::get) No implementation"

class Just extends Maybe 
  constructor: (@v) -> super()
  toString: -> "Just(#{@v})"
  isDefined: -> true
  orElse: (_v) -> @
  getOrElse: (_v) -> @v
  get: -> @v
  equals: (x) -> x instanceof Just and @v.equals x.get()
    
class Nothing extends Maybe
  toString: -> "Nothing"
  isDefined: -> false
  orElse: (v) -> just v()
  getOrElse: (v) -> v()
  get: -> throw new Error "Nothing.get"
  equals: (x) -> x instanceof Nothing
    
just = (value) -> new Just value

nothing = lazy -> new Nothing()

export {just, nothing}
