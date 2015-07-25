require "./lib/parser"
require "./lib/env"

module Lasp
  module_function

  def execute(program, env = global_env)
    Lasp::eval(Lasp::parse(program), env)
  end

  def eval(ast, env = global_env)
    case ast
    when Array  then eval_form(ast, env)
    when Symbol then env[ast]
    else ast
    end
  end

  def eval_form(ast, env)
    if ast.first == :def
      _, key, value = *ast
      env[key] = value
    else
      head, *tail = *ast
      fn = env[head]
      fn.(env, *tail.map { |form| eval(form) })
    end
  end
end
