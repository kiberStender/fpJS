import Monad from "typeclass/monad/Monad.coffee"

export default class State extends Monad
  constructor: (@run) -> super()
  fmap: (f) -> new State (s) =>
    [a, t] = @run s
    [(f a), t]

  flatMap: (f) -> new State (s) =>
    [a, t] = @run s
    (f a).run t

  evaluate: (s) -> @run(s)[0]

  @insert: (a) -> new State (s) -> [a, s]
  @get: (f) -> new State (s) -> [(f s), s]
  @mod: (f) -> new State (s) -> [[], f s]
