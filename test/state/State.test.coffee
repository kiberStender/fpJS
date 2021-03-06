import chai from "chai"
import {map} from "collections/map/Map.coffee"
import State from "state/State.coffee"

chai.should()

fibMemo = (n) ->
  fibmemoR = (z) -> if z <= 1 then State.insert z
  else State.get((m) -> m.get z).flatMap (u) -> u.fmap(State.insert).getOrElse(->
    fibmemoR(z - 1).flatMap (r) -> fibmemoR(z - 2).flatMap (s) -> do (t = r + s) ->
      State.mod((m) -> m.cons [z, t]).fmap (_) -> t
  ).fmap (v) -> v

  fibmemoR(n).evaluate map()

describe "State monad Instances", -> it "fibMemo 30 should be 832040", -> fibMemo(30).should.equal 832040
