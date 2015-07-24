require "./lib/parser"
require "./lib/core_lib"

module Lasp
  def self.eval(ast, env = CORE_LIB)
    if Array === ast
      head, *tail = *ast
      fn = env[head]
      fn.(*tail.map { |form| eval(form) })
    else
      ast
    end
  end
end
