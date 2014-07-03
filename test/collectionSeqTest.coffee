chai = require "chai"
chai.should()

{fpJS: {seq, Cons, nil}} = require "../src/fpJS.coffee"

describe "Seq instances", ->
  s = seq 1, 2, 3
  fx = (x) -> x * 2
  fxx = (x) -> seq x * 2
  sfx = seq ((x) -> x + 1), ((x) -> x * 2)
  sfxr = -> seq 2, 3, 4, 2, 4, 6
  
  it "Seq(1, 2, 3) should be equals to Seq(1, 2, 3)", -> chai.expect(s.equals s).to.be.true
  it "Seq(1, 2, 3) shoud be different from Nil", -> chai.expect(s.equals nil).to.be.false
  it "Nil shoud be equals to Nil", -> chai.expect(nil.equals nil).to.be.true
  it "Seq(1, 2, 3) should map fx to Seq(2, 4, 6)", -> chai.expect(s.fmap(fx).equals seq 2, 4, 6).to.be.true
  it "Nil should map fx to Nil", -> chai.expect(nil.fmap(fx).equals nil).to.be.true
  it "Seq(Seq(1, 2), Seq(3, 4), Seq(5, 6)) should flatten to Seq(1, 2, 3, 4, 5, 6)", -> 
    chai.expect(seq((seq 1, 2), (seq 3, 4), (seq 5, 6)).flatten().equals seq 1, 2, 3, 4, 5, 6).to.be.true
  it "Seq(1, 2, 3) should fmap fxx to Seq(Seq(2), Seq(4), Seq(6))", -> chai.expect(s.fmap(fxx).equals seq (seq 2), (seq 4), (seq 6)).to.be.true
  it "Seq(1, 2, 3) should bind fxx to Seq(2, 4, 6)", -> chai.expect(s.bind(fxx).equals seq 2, 4, 6).to.be.true
  it "Seq(1, 2, 3) should afmap sfx to Seq(2, 3, 4, 2, 4, 6)", -> chai.expect(s.afmap(sfx).equals sfxr()).to.be.true