import Applicative from "typeclass/applicative/Applicative.coffee"

export default class Monad extends Applicative
  identity: (a) -> a
  #Haskell >>= function
  flatMap: (fn) -> throw Error "(Monad::flatMap) No implementation"
