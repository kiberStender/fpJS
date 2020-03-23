import chai from "chai"
import {set} from "collections/set/Set.coffee"
import {seq, arrayToSeq} from "collections/seq/Seq.coffee"
import Ordering from "ordering/Ordering.coffee"
import {lazy} from "utils/lazy.coffee"

chai.should()

class Person extends Ordering
  constructor: (@name, @surname) -> super()
  compare: (p) -> if @name is p.name then 0 else (if @name < p.name then -1 else 1)
  toString: () -> "Person(#{@name}, #{@surname})"
  
person = (name, surname) -> new Person name, surname

describe "Set instances", ->  
  #Functions
  assert = (expr, msg) -> if not expr then throw new Error(msg || 'failed')
  aSet = lazy -> set 3, 2, 5
  aSeq = lazy -> seq 5, 2, 4, 1
  pSeq = [person("kiber", "bobo"), person("cesar", "besta"), person("douglas", "pastor")]
  
  it "Set 3, 2, 5 should be 2, 3, 5" , -> assert aSet().toString() == "Set(2, 3, 5)"
  it "Set head should be 2", -> assert aSet().head() == 2, "Value should be 2 but is #{aSet().head()}"
  it "Seq(5, 2, 4, 1) should become Set(1, 2, 4, 5)", -> assert aSeq().toSet().equals(set(1, 2, 4, 5))
  it "person sequence should become a set using arrayToSeq", -> 
    nSet = arrayToSeq(pSeq).toSet()
    assert(nSet.toString().equals("Set(Person(cesar, besta), Person(douglas, pastor), Person(kiber, bobo))"), "Actual value #{nSet}")
