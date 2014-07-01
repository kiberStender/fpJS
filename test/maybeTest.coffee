chai = require "chai"
chai.should()

{fpJS: {Maybe, Just, nothing}} = require "../src/fpJS.coffee"

describe "Maybe Instances", ->
  fx = (x) -> x + 5
  fxx = (x) -> new Just x + 5
  j = new Just 10
  it "Just(10) should be equals Just(10)", -> chai.expect(j.equals j).to.be.true
  it "Nothing should be equals Nothing", -> chai.expect(nothing.equals nothing).to.be.true
  it "Just(10) should map fx to Just(15)", -> chai.expect(j.fmap(fx).equals new Just 15).to.be.true
  it "Just(10) should not be equals to Nothing", -> chai.expect(j.equals nothing).to.be.false
  it "Nothing should map fx to Nothing", -> chai.expect(nothing.fmap(fx).equals nothing).to.be.true
  it "Just(10) should map fxx to Just(Just(15))", -> chai.expect(j.fmap(fxx).equals new Just new Just 15).to.be.true
  it "Just(10) should bind fxx to Just(15)", -> chai.expect(j.bind(fxx).equals new Just 15).to.be.true
  it "Nothing should bind fxx to Nothing", -> chai.expect((nothing).bind(fxx).equals nothing).to.be.true
  it """Just(10) should "afmap" Just(x + 5) to Just(15)""", -> chai.expect(j.afmap(new Just (x) ->  x + 5).equals new Just 15).to.be.true
  it "Just(10).get should be 10", -> j.get().should.equal 10
  it "Nothing.get should throw a Nothing.get", -> chai.expect(-> (nothing).get()).to.throw "Nothing.get"
  it "Just(10).getOrElse(15) should be 10", -> j.getOrElse(-> 15).should.equal 10
  it "Nothing.getOrElse(15) should be 15", -> (nothing).getOrElse(-> 15).should.equal 15