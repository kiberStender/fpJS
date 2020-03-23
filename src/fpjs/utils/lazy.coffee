lazy = (fn) ->
  val = null
  isEvaluated = false  
  return -> if isEvaluated then val
  else 
    isEvaluated = true
    val = fn()
    
export {lazy}
