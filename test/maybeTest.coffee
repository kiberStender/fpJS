chai = require "chai"
chai.should()

{fpJS: {Maybe, Just, Nothing}} = require "../src/fpJS.coffee"

describe "Maybe Instances", ->
  fx = (x) -> x + 5
  fxx = (x) -> new Just x + 5
  it "Maybe should not instantiate", -> chai.expect(-> new Maybe).to.throw "No direct constructor"
  it "Just(10) should be equals Just(10)", -> chai.expect(new Just(10).equals new Just 10).to.be.true
  it "Nothing should be equals Nothing", -> chai.expect(new Nothing().equals new Nothing()).to.be.true
  it "Just(10) should map fx to Just(15)", -> chai.expect((new Just 10).fmap(fx).equals new Just 15).to.be.true
  it "Just(10) should not be equals to Nothing", -> chai.expect((new Just 10).equals new Nothing()).to.be.false
  it "Nothing should map fx to Nothing", -> chai.expect(new Nothing().fmap(fx).equals new Nothing()).to.be.true
  it "Just(10) should map fxx to Just(Just(15))", -> chai.expect((new Just 10).fmap(fxx).equals new Just new Just 15).to.be.true
  it "Just(10) should bind fxx to Just(15)", -> chai.expect((new Just 10).bind(fxx).equals new Just 15).to.be.true
  it "Nothing should bind fxx to Nothing", -> chai.expect((new Nothing()).bind(fxx).equals new Nothing()).to.be.true
  it """Just(10) should "afmap" Just(x + 5) to Just(15)""", -> chai.expect((new Just 10).afmap(new Just (x) ->  x + 5).equals new Just 15).to.be.true
  it "Just(10).get should be 10", -> (new Just 10).get().should.equal 10
  it "Nothing.get should throw a Nothing.get", -> chai.expect(-> (new Nothing()).get()).to.throw "Nothing.get"
  it "Just(10).getOrElse(15) should be 10", -> (new Just 10).getOrElse(-> 15).should.equal 10
  it "Nothing.getOrElse(15) should be 15", -> (new Nothing()).getOrElse(-> 15).should.equal 15