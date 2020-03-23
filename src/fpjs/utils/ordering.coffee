#Adding Ordering to all objects and instances of native JS

Object::equals = Object::equals or (o) -> @toString() is o.toString()
Object::compare = Object::compare or (x) -> throw Error "(Object::compare) No implementation"
Object::lessThan = Object::lessThan or (x) -> (@compare x) is -1
Object::greaterThan = Object::greaterThan or (x) -> (@compare x) is 1

#Adding Ordering to Native JS objects
Number::compare = (x) -> if typeof x is "number"
  if +@ is x then 0 else if +@ < x then -1 else 1
else -2

String::compare = (s) -> if typeof s is "string"
  if (@ + '') is s then 0 else if (@ + '') < s then -1 else 1
else -2
