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
  it "Map should append a new item", -> 
    chai.expect(mi.cons([3, "scalise"]).equals map([1, "kleber"], [2, "eduardo"], [3, "scalise"])).to.be.true
  it "Map should append a new item and keep order", ->
    chai.expect(md.cons([0, 2.5]).equals map([0, 2.5], [1, 2.0])).to.be.true
  it "Map should concat another Map and keep order", -> 
    chai.expect(md.concat(map([3, 8.75], [0, 1.9])).equals map([0, 1.9], [1, 2.0], [3, 8.75])).to.be.true
  it "Head should be (1 -> kleber)", -> chai.expect(name.head().equals [1, "kleber"]).to.be.true
  it "Tail should be Map((2, eduardo), (3, scalise), (4 -> stender))", -> 
    chai.expect(name.tail().equals map([2, "eduardo"], [3, "scalise"], [4, "stender"])).to.be.true
  it "Init should Map((1 -> kleber), (2 -> eduardo), (3 -> scalise))", -> 
    chai.expect(name.init().equals map [1, "kleber"], [2, "eduardo"], [3, "scalise"]).to.be.true
  it "Init should Map((4, stender))", -> chai.expect(name.last().equals [4, "stender"]).to.be.true