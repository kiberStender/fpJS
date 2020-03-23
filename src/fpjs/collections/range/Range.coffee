import {Seq} from "collections/seq/Seq.coffee"

class Range extends Seq 
  constructor: (@start, @end, @step = 1) -> super()
    
  prefix: -> "Range"
  head: -> @start
  tail: -> if @isEmpty() then nil() else new Range (@start + @step), @end, @step
  isEmpty: -> @start > @end
      
  toStringFrmt: (acc) -> (item) -> if acc is "" then item else "#{acc}, #{item}"
    
  by: (st) -> new Range start, end, st
    
Number::to = (end) -> new Range (@ + 0), end
Number::until = (end) -> new Range (@ + 0), (end - 1)
