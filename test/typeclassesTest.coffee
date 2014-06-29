chai = require "chai"
chai.should()

{fpJS: {Functor, Applicative, Monad}} = require "../src/fpJS.coffee"

describe 'Typeclasses instances', -> 
  it 'Functor should not instantiate', -> chai.expect(-> new Functor).to.throw "No direct constructor"
  it 'Applicative should not instantiate', -> chai.expect(-> new Applicative).to.throw "No direct constructor"
  it 'Monad should not instantiate', -> chai.expect(-> new Monad).to.throw "No direct constructor"
