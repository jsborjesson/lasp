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
    when :def then def_special_form(tail, env)
    when :fn  then fn_special_form(tail, env)
    when :do  then do_special_form(tail, env)
    when :if  then if_special_form(tail, env)
    when Proc then head.(*tail)
    else call_function(head, tail, env)
    end
  end

  def call_function(symbol, args, env)
    fn = Lasp::eval(symbol, env)
    fn.(*args.map { |form| Lasp::eval(form, env) })
  end

  def def_special_form(form, env)
    key, value = form
    env[key] = Lasp::eval(value, env)
  end

  def fn_special_form(form, env)
    params, func = form
    -> (*args) { Lasp::eval(func, env.merge(Hash[params.zip(args)])) }
  end

  def do_special_form(form, env)
    form.map { |form| Lasp::eval(form, env) }.last
  end

  def if_special_form(form, env)
    conditional, true_form, false_form = form
    Lasp::eval(conditional, env) ? Lasp::eval(true_form, env) : Lasp::eval(false_form, env)
  end
end
