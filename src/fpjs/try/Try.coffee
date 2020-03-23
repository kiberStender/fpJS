import Monad from "typeclass/monad/Monad"

class Try extends Monad
  @apply: (fn) -> try success fn() catch e then failure e
    
#syntax sugar for Try.apply
_try = Try.apply

class Success extends Try
  constructor: (value) ->
    super()
    @value_ = value
  flatMap: (f) -> try f value catch e then failure e
  fmap: (fn) -> _try -> fn value
  getOrElse: (v) -> value
  toString: -> "Success(#{@value_})"

class Failure extends Try 
  constructor: (exception) ->
    super()
    @exception_ = exception
  flatMap: (f) -> @
  fmap: (fn) -> @
  getOrElse: (v) -> v()
  toString: -> "Failure(#{@exception_})"
    
success = (value) -> new Success value
failure = (excp) -> new Failure excp

export {success, failure, _try}
