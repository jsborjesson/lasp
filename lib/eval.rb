require "./lib/parser"
require "./lib/core_lib"

module Lasp
  module_function

  def execute(program)
    Lasp::eval(Lasp::parse(program))
  end

  def eval(ast, env = CORE_LIB)
    if Array === ast
      head, *tail = *ast
      fn = env[head]
      fn.(*tail.map { |form| eval(form) })
    else
      ast
    end
  end
end
