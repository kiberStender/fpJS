import Any from "any/Any"

class Unit extends Any
  equals: (u) -> u instanceof Unit
  toString: -> "Unit"
    
unit = lazy -> new Unit()

export {unit}
