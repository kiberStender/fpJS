import chai from "chai"
import {lazy} from "utils/lazy.coffee"
import {just, nothing} from "maybe/Maybe.coffee"

chai.should()

describe "Maybe Instances", ->
  fx = (x) -> x + 5
  fxx = (x) -> just x + 5
  j = just 10
  it "Just(10) should be equals Just(10)", -> chai.expect(j.equals j).to.be.true
  it "Nothing should be equals Nothing", -> chai.expect(nothing().equals nothing()).to.be.true
  it "Just(10) should map fx to Just(15)", -> chai.expect(j.fmap(fx).equals just 15).to.be.true
  it "Just(10) should not be equals to Nothing", -> chai.expect(j.equals nothing()).to.be.false
  it "Nothing should map fx to Nothing", -> chai.expect(nothing().fmap(fx).equals nothing()).to.be.true
  it "Just(10) should map fxx to Just(Just(15))", -> chai.expect(j.fmap(fxx).equals just just 15).to.be.true
  it "Just(10) should flatMap fxx to Just(15)", -> chai.expect(j.flatMap(fxx).equals just 15).to.be.true
  it "Nothing should flatMap fxx to Nothing", -> chai.expect(nothing().flatMap(fxx).equals nothing()).to.be.true
  it """Just(10) should "afmap" Just(x + 5) to Just(15)""", -> chai.expect(j.afmap(just (x) ->  x + 5).equals just 15).to.be.true
  it "Just(10).get should be 10", -> j.get().should.equal 10
  it "Nothing.get should throw a Nothing.get", -> chai.expect(-> nothing().get()).to.throw "Nothing.get"
  it "Just(10).getOrElse(15) should be 10", -> j.getOrElse(-> 15).should.equal 10
  it "Nothing.getOrElse(15) should be 15", -> nothing().getOrElse(-> 15).should.equal 15
