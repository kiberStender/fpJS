#Adding compose and andThen to native Function class
Function::compose = Function::compose or (g) -> (x) => @ g x
Function::andThen = Function::andThen or (g) -> (x) => g @ x
