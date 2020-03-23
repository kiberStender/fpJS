export default class Any
  toString: -> "#{@}"
  hashCode: -> 13
  equals: (x) -> x instanceof Any and @hashCode() is x.hashCode()
