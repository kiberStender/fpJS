chai = require "chai"
chai.should()

{fpJS: {map}} = require "../src/fpJS.coffee"

describe "Map instances", ->
  mi = map [1, "kleber"], [2, "eduardo"]
  md = map [1, 2.0]
  messedName = map([4, "stender"], [2, "eduardo"], [1, "kleber"], [3, "scalise"])
  name = map([1, "kleber"], [2, "eduardo"], [3, "scalise"], [4, "stender"])
  
  it "Map should be equal itself", -> chai.expect(mi.equals mi).to.be.true
  it "Map should be differente from other kinds of Map", -> chai.expect(mi.equals md).to.be.false
  it "The constructor should organize the data", -> chai.expect(messedName.equals name).to.be.true
  it "Maps cannot has duplicated data", -> chai.expect(map([1, 3.5], [1, 2.0]).equals map([1, 2.0])).to.be.true