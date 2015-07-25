require "./lib/parser"
require "./lib/env"

module Lasp
  module_function

  def execute(program, env = global_env)
    Lasp::eval(Lasp::parse(program), env)
  end

  def eval(ast, env = global_env)
    if Array === ast
      head, *tail = *ast
      fn = env[head]
      fn.(env, *tail.map { |form| eval(form) })
    else
      ast
    end
  end
end
