chai = require "chai"
chai.should()

{fpJS: {seq, Cons, nil, arrayToSeq}} = require "../src/fpJS.coffee"

describe "Seq instances", ->
  s = seq 1, 2, 3
  flatMapMaybe = (s) -> s.find((x) -> x is 1).flatMap (one) -> s.find((x) -> x is 2).flatMap (two) -> s.find((x) -> x > 4).fmap (gt4) -> one + two + gt4
  fx = (x) -> x * 2
  fxx = (x) -> seq x * 2
  sfx = seq ((x) -> x + 1), ((x) -> x * 2)
  sfxr = -> seq 2, 3, 4, 2, 4, 6
  
  it "Seq(1, 2, 3) should be equals to Seq(1, 2, 3)", -> chai.expect(s.equals s).to.be.true
  it "Seq(1, 2, 3) shoud be different from Nil", -> chai.expect(s.equals nil()).to.be.false
  it "Nil shoud be equals to Nil", -> chai.expect(nil().equals nil()).to.be.true
  it "Seq(1, 2, 3) should map fx to Seq(2, 4, 6)", -> chai.expect(s.fmap(fx).equals seq 2, 4, 6).to.be.true
  it "Nil should map fx to Nil", -> chai.expect(nil().fmap(fx).equals nil()).to.be.true
  it "Seq(Seq(1, 2), Seq(3, 4), Seq(5, 6)) should flatten to Seq(1, 2, 3, 4, 5, 6)", -> 
    chai.expect(seq((seq 1, 2), (seq 3, 4), (seq 5, 6)).flatten().equals seq 1, 2, 3, 4, 5, 6).to.be.true
  it "Seq(1, 2, 3) should fmap fxx to Seq(Seq(2), Seq(4), Seq(6))", -> chai.expect(s.fmap(fxx).equals seq (seq 2), (seq 4), (seq 6)).to.be.true
  it "Seq(1, 2, 3) should flatMap fxx to Seq(2, 4, 6)", -> chai.expect(s.flatMap(fxx).equals seq 2, 4, 6).to.be.true
  it "Seq(1, 2, 3) should afmap sfx to Seq(2, 3, 4, 2, 4, 6)", -> chai.expect(s.afmap(sfx).equals sfxr()).to.be.true
  it "flatMapMaybe(Seq(1, 2, 3, 4, 5)).get() shoud be 8", -> flatMapMaybe(seq 1, 2, 3, 4, 5).get().should.equal 8
  it "Seq(1, 2, 3) should filter to 1", -> chai.expect(s.filter((x) -> x < 2).equals seq 1).to.be.true
  it "Seq(1, 2, 3) should concat to Seq(1, 2, 3, 1, 2, 3)", -> chai.expect(s.concat(s).equals seq 1, 2, 3, 1, 2, 3).to.be.true
  it "Seq(1, 2, 3) should foldLeft + to 6", -> ((s.foldLeft 0) (acc) -> (x) -> acc + x).should.equal 6
  it "Seq(1, 2, 3) should be reversed to Seq(3, 2, 1)", -> chai.expect(s.reverse().equals seq 3, 2, 1).to.be.true
  it "[1, 2, 3] should be mapped to Seq(1, 2, 3)", -> chai.expect((arrayToSeq [1, 2, 3]).equals seq 1, 2, 3).to.be.true
  it "[[1, 2], [3, 4], [5, 6]] should be mapped to Seq(seq(1, 2), seq(3, 4), seq(5, 6))", -> 
    chai.expect((arrayToSeq [[1, 2], [3, 4], [5, 6]]).equals seq (seq 1, 2), (seq 3, 4), (seq 5, 6)).to.be.true
  it "Seq(1, 2, 3, 4) should be splited at middle and be a tuple of [Seq(1, 2). Seq(3, 4)]", ->
    chai.expect(seq(1, 2, 3, 4).splitAt(2).equals [seq(1, 2), seq(3, 4)]).to.be.true
  it "Seq(1, 2, 3) should zip Seq(4, 5, 6) to Seq((1, 4), (2, 5), (,3, 6))", ->
    chai.expect(seq(1, 2, 3).zip(seq 4, 5, 6).equals seq [1, 4], [2, 5], [3, 6]).to.be.true
  it "Seq(1, 2, 3) should zipWith Seq(4, 5, 6)(+) to Seq(5, 7, 9)", ->
    chai.expect(seq(1, 2, 3).zipWith(seq 4, 5, 6)((x) -> x[0] + x[1]).equals seq 5, 7, 9).to.be.true