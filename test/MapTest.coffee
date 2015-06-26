chai = require "chai"
chai.should()

{fpJS: {map, just}} = require "../src/fpJS.coffee"

describe "Map instances", ->
  mi = map [1, "kleber"], [2, "eduardo"]
  md = map [1, 2.0]
  messedName = map([4, "stender"], [2, "eduardo"], [1, "kleber"], [3, "scalise"])
  name = map([1, "kleber"], [2, "eduardo"], [3, "scalise"], [4, "stender"])
  nameMap = map ["scalise", 3], ["stender", 4], ["kleber", 1], ["eduardo", 2]
  eq = "Map((eduardo -> 2), (kleber -> 1), (scalise -> 3), (stender -> 4))"
  
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
  it "Last should Map((4, stender))", -> chai.expect(name.last().equals [4, "stender"]).to.be.true
  it "Find should return an item whose key is 2", -> 
    chai.expect(mi.find((x) -> x[0].equals 2).equals just [2, "eduardo"]).to.be.true
  it "Get should return an item whose value is scalise", -> chai.expect(name.get(3).equals just "scalise").to.be.true
  it "FoldLeft (-) shoul return -3", -> ((mi.foldLeft 0) (acc) -> (item) -> acc - item[0]).should.equal -3
  it "FoldRight (-) shoul return -3", -> ((mi.foldRight 0) (item) -> (acc) -> acc - item[0]).should.equal -3
  it "Map((1, kleber), (2, eduardo)) should map to Map((1, kleberk), (2, eduardok))", ->
    chai.expect(mi.fmap((x) -> [x[0], x[1] + 'k']).equals map([1, "kleberk"], [2, "eduardok"])).to.be.true
  it "Map((1 -> kleber), (2 -> eduardo)) should map to Map((1k -> kleberk), (2k -> eduardo))", ->
    chai.expect(mi.fmap((x) -> [x[0] + 1, x[1]]).equals map([2, "kleber"], [3, "eduardo"])).to.be.true
  it "Map((1, kleber), (2, eduardo)) should flatMap to Map((1, kleberk), (2, eduardok))", ->
    chai.expect(mi.flatMap((x) -> map [x[0], x[1] + 'k']).equals map([1, "kleberk"], [2, "eduardok"])).to.be.true
  it "Map((1 -> kleber), (2 -> eduardo)) should flatMap to Map((1k -> kleberk), (2k -> eduardo))", ->
    chai.expect(mi.flatMap((x) -> map [x[0] + 1, x[1]]).equals map([2, "kleber"], [3, "eduardo"])).to.be.true
  it "nameMap.toString() should be equals #{eq})", -> chai.expect(nameMap.toString().equals eq).to.be.true