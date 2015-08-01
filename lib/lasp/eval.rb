require "lasp/parser"
require "lasp/env"

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
      # Use env from context to properly scope closures
      -> (_, *args) { eval(func, env.merge(Hash[params.zip(args)])) }
    elsif head == :do
      tail.each do |form| eval(form, env) end
    elsif head == :if
      conditional, true_form, false_form = tail
      eval(conditional, env) ? eval(true_form, env) : eval(false_form, env)
    elsif Proc === head
      head.(env, *tail)
    else
      fn = eval(head, env)
      fn.(env, *tail.map { |form| eval(form, env) })
    end
  end
end
