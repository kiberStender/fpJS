chai = require "chai"
chai.should()

{fpJS} = require "../src/fpJS.coffee"
{set, seq, Ordering, arrayToSeq} = fpJS.withAllExtension()

class Person extends Ordering then constructor: (@name, @surname) ->
  @compare = (p) -> if name is p.name then 0 else (if name < p.name then -1 else 1)
  @toString = -> "Person(#{name}, #{surname})"
  
person = (name, surname) -> new Person name, surname

describe "Set instances", ->
  # Lazy vals
  set_ = null
  seq_ = null
  
  #Functions
  assert = (expr, msg) -> if not expr then throw new Error(msg || 'failed')
  aSet = -> if set_ is null then set_ = set 3, 2, 5 else set_
  aSeq = -> if seq_ is null then seq_ = seq 5, 2, 4, 1 else seq_
  pSeq = [person("kiber", "bobo"), person("cesar", "besta"), person("pastor", "viado")]
  
  it "Set 3, 2, 5 should be 2, 3, 5" , -> assert aSet().toString() == "Set(2, 3, 5)"
  it "Set head should be 2", -> assert aSet().head() == 2, "Value should be 2 but is #{aSet().head()}"
  it "Seq(5, 2, 4, 1) should become Set(1, 2, 4, 5)", -> assert aSeq().toSet().equals(set(1, 2, 4, 5))
  it "person sequence should become a set using arrayToSeq", -> 
    nSet = arrayToSeq(pSeq).toSet()
    assert(nSet.toString().equals("Set(Person(cesar, besta), Person(kiber, bobo), Person(pastor, viado))"), "Actual value #{nSet}")