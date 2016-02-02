require "lasp/parser"
require "lasp/env"
require "lasp/fn"
require "lasp/macro"

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
    when :def   then def_special_form(tail, env)
    when :fn    then fn_special_form(tail, env)
    when :do    then do_special_form(tail, env)
    when :if    then if_special_form(tail, env)
    when :macro then macro_special_form(tail, env)
    else call_function(head, tail, env)
    end
  end

  def call_function(symbol, args, env)
    fn = Lasp::eval(symbol, env)

    case fn
    when Macro then Lasp::eval(fn.(*args), env)
    else fn.(*args.map { |form| Lasp::eval(form, env) })
    end
  end

  def def_special_form(form, env)
    key, value = form
    env[key] = Lasp::eval(value, env)
  end

  def fn_special_form(form, env)
    params, func = form
    Fn.new(params, func, env)
  end

  def do_special_form(form, env)
    form.map { |form| Lasp::eval(form, env) }.last
  end

  def if_special_form(form, env)
    conditional, true_form, false_form = form
    Lasp::eval(conditional, env) ? Lasp::eval(true_form, env) : Lasp::eval(false_form, env)
  end

  def macro_special_form(form, env)
    params, func = form
    Macro.new(params, func, env)
  end
end
