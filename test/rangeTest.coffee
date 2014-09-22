chai = require "chai"

{fpJS: {Range, seq}} = require "../src/fpJS.coffee"

describe "Range instances", ->
  r = 1.to 3
  it "r should be a Range(1...3)", ->
  it "Range(1..3) should be mapped to Seq(2, 4)", -> chai.expect((r.fmap (x) -> x * 2).equals seq 2, 4, 6).to.be.true