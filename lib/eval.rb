require "./lib/parser"
require "./lib/env"

module Lasp
  module_function

  def execute(program, env = global_env)
    Lasp::eval(Lasp::parse(program), env)
  end

  def eval(ast, env)
    if Symbol === ast
      env.fetch(ast)
    elsif not Array === ast
      ast
    elsif ast.first == :def
      _, key, value = ast
      env[key] = eval(value, env)
    elsif ast.first == :fn
      _, params, func = *ast
      -> (_, *args) { eval(func, env.merge(Hash[params.zip(args)])) }
    elsif Proc === ast.first
      head, *tail = *ast
      head.call(env, *tail)
    else
      head, *tail = *ast
      fn = eval(head, env)
      fn.(env, *tail.map { |form| eval(form, env) })
    end
  end
end
