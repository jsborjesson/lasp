require "./lib/parser"
require "./lib/env"

module Lasp
  module_function

  def execute_file(path)
    execute(File.read(path))
  end

  def execute(program, env = global_env)
    Lasp::eval(Lasp::parse(program), env)
  end

  def eval(ast, env)
    case ast
    when Symbol then env.fetch(ast)
    when Array  then eval_form(ast, env)
    else ast
    end
  end

  def eval_form(form, env)
    head, *tail = *form

    if head == :def
      key, value = tail
      env[key] = eval(value, env)
    elsif head == :fn
      params, func = tail
      -> (env, *args) { eval(func, env.merge(Hash[params.zip(args)])) }
    elsif head == :begin
      tail.each do |form| eval(form, env) end
    elsif Proc === head
      head.(env, *tail)
    else
      fn = eval(head, env)
      fn.(env, *tail.map { |form| eval(form, env) })
    end
  end
end
