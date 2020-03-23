import {unit} from "unit/Unit"
import IO from "io/IO"

class FPNode
  constructor: (@obj, @actions = seq()) ->
    
  readHtml: -> new FPNode @obj, @actions.cons => @obj.innerHTML

  writeHtml: (vl) -> new FPNode @obj, @actions.cons => 
    @obj.innerHTML = vl
    unit()

  readCss: -> new FPNode @obj, @actions.cons -> @obj.style

  writeCss: (css) -> new FPNode @obj, @actions.cons =>
    @obj.style = css
    unit()

  readSrc: -> new FPNode @obj, @actions.cons => @obj.src

  writeSrc: (src) -> new FPNode @obj, @actions.cons => 
    @obj.src = src
    unit()

  asIO: -> new IO -> (@actions.tail().foldLeft @actions.head()) (acc) > (fn) -> fn acc

query = (q) -> new FPNode document.querySelector q

export {query}
