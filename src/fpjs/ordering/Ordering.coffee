import Any from "any/Any.coffee"

export default class Ordering extends Any
  compare: (x) -> throw Error "(Ordering::compare) No implementation"
  lessThan: (x) -> (@compare x) is -1
  greaterThan: (x) -> (@compare x) is 1
