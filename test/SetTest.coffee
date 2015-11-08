chai = require "chai"
chai.should()

{fpJS: {set}} = require "../src/fpJS.coffee"

describe "Set instances", ->
  # Lazy vals
  set_ = null
  
  #Functions
  assert = (expr, msg) -> if not expr then throw new Error(msg || 'failed')
  aSet = -> if set_ is null then set_ = set 3, 2, 5 else set_
  
  it "Set 3, 2, 5 should be 2, 3, 5" , -> assert aSet().toString() == "Set(2, 3, 5)"
  it "Set head should be 2", -> assert aSet().head() == 2, "Value should be 2 but is #{aSet().head()}"