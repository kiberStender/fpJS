chai = require "chai"

{fpJS} = require "../src/fpJS.coffee"
{seq}= fpJS.withAllExtension()

describe "Range instances", ->
  r = 1.to 3
  it "r should be a Range(1...3)", ->
  it "Range(1..3) should be mapped to Seq(2, 4, 6)", -> chai.expect((r.fmap (x) -> x * 2).equals seq 2, 4, 6).to.be.true
  it "Range(1..3) should flatMap to Seq(2, 4, 6)", -> 
    console.log (r.flatMap (x) -> x.to(x * 2)).toString()
    chai.expect((r.flatMap (x) -> x.to(x * 2)).equals seq 1, 2, 2, 3, 4, 3, 4, 5, 6).to.be.true