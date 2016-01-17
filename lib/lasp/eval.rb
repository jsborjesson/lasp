require "lasp/parser"
require "lasp/env"

module Lasp
  module_function

  def eval(form, env)
    case form
    when Symbol then env.fetch(form)
    when Array  then eval_form(form, env)
    else form
    end
  end

  def eval_form(form, env)
    head, *tail = *form

    case head
    when :def
      key, value = tail
      env[key] = Lasp::eval(value, env)
    when :fn
      params, func = tail
      -> (*args) { Lasp::eval(func, env.merge(Hash[params.zip(args)])) }
    when :do
      tail.map { |form| Lasp::eval(form, env) }.last
    when :if
      conditional, true_form, false_form = tail
      Lasp::eval(conditional, env) ? Lasp::eval(true_form, env) : Lasp::eval(false_form, env)
    when Proc
      head.(*tail)
    else
      fn = Lasp::eval(head, env)
      fn.(*tail.map { |form| Lasp::eval(form, env) })
    end
  end
end
