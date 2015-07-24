require "./lib/parser"
require "./lib/core_lib"

module Lasp
  def self.eval(ast, env = CORE_LIB)
    if Array === ast
      head, *tail = *ast
      fn = env[head]
      tail.map { |form| eval(form) }

      fn.(*tail)
    else
      ast
    end
  end
end
