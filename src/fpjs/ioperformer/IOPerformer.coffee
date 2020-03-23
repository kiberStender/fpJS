import IO from "io/IO"

ioPerform = (fn) -> (str = "") -> new IO -> (fn.andThen (_) -> unit()) str

consoleIO = ioPerform console.log.bind console
alertIO = ioPerform alert

main = (fn) -> document.addEventListener "DOMContentLoaded", (event) -> fn(event).unsafePerformIO()
  

export  {alertIO, consoleIO, main}
