import Any from "any/Any"

class Either extends Any 
  fold: (rfn, lfn) -> if @isRight() then rfn @value() else lfn @value()

class Right extends Either 
  constructor: (value) ->
    super()
    @value_ = value
  value: -> @value_
  isRight: -> true
  isLeft: -> false
  toString: -> "Right(#{value})"

class Left extends Either
  constructor: (value) ->
    super()
    @value_ = value
  value: -> @value_
  isRight: -> false
  isLeft: -> true
  toString: -> "Left(#{value})"
    
right = (value) -> new Right value
left = (value) -> new Left value

export {righ, left}
