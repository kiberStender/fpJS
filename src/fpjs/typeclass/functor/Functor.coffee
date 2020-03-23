import Any from "any/Any.coffee"

export default class Functor extends Any
  #method to map the internal data of type A into a data of type B
  fmap: (fn) -> throw Error "(Functor::fmap) No implementation"
