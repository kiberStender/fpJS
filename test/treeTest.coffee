chai = require "chai"
chai.should()

{fpJS: {emptyBranch, Branch}} = require "../src/fpJS.coffee"

describe "Tree instances", ->
  it "Empty should be empty", -> emptyBranch.toString().should.equals ""