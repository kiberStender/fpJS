import Functor from "typeclass/functor/Functor.coffee"

export default class Applicative extends Functor
  #Haskell <*> function
  afmap: (fn) -> throw Error "(Applicative::afmap) No implementation"
