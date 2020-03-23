import {just, nothing} from "maybe/Maybe.coffee"

m = just 5
n = nothing()
o = m.flatMap (x) => n.fmap (y) => x + y

console.log o
