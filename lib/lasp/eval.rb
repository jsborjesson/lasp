require "lasp/parser"
require "lasp/env"

module Lasp
  module_function

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
      env[key] = Lasp::eval(value, env)
    elsif head == :fn
      params, func = tail
      -> (*args) { Lasp::eval(func, env.merge(Hash[params.zip(args)])) }
    elsif head == :do
      tail.map { |form| Lasp::eval(form, env) }.last
    elsif head == :if
      conditional, true_form, false_form = tail
      Lasp::eval(conditional, env) ? Lasp::eval(true_form, env) : Lasp::eval(false_form, env)
    elsif Proc === head
      head.(*tail)
    else
      fn = Lasp::eval(head, env)
      fn.(*tail.map { |form| Lasp::eval(form, env) })
    end
  end
end
