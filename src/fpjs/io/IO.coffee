import Monad from "typeclass/monad/Monad"

export default class IO extends Monad
  constructor: (f) ->
    super()
    @f = f
  unsafePerformIO: -> @f()
  join: (action) -> new IO -> action.unsafePerformIO().unsafePerformIO()
  fmap: (fn) -> new IO => fn @unsafePerformIO()
  flatMap: (fn) -> @join @fmap fn
  foreach: (io) -> @flatMap (a) -> io
  toString: -> "IO"
