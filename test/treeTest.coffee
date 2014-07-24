chai = require "chai"
chai.should()

{fpJS: {emptyBranch, Branch}} = require "../src/fpJS.coffee"

describe "Tree instances", ->
  b = new Branch emptyBranch(), 10, emptyBranch()
  it "Empty should be empty", -> emptyBranch().toString().should.equals ""
  it "Branch(empty, 10, empty) should be equals Branch(empty, 10, empty)", -> chai.expect(b.equals b).to.be.true
  it "Branch(empty, 10, empty) should be different to empty", -> chai.expect(b.equals emptyBranch()).to.be.false
  it "Branch(empty, 10, empty) should be different to Branch(empty, 6, empty)", -> chai.expect(b.equals new Branch emptyBranch(), 6, emptyBranch()).to.be.false