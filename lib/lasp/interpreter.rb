require "lasp"
require "lasp/fn"
require "lasp/macro"
require "lasp/errors"

module Lasp
  class Interpreter
    def self.eval(form, env)
      new.eval(form, env)
    end

    def eval(form, env)
      case form
      when Symbol then resolve_symbol(form, env)
      when Array  then eval_form(form, env)
      else form
      end
    end

    private

    def eval_form(form, env)
      head, *tail = *form

      case head
      when :def     then def_special_form(tail, env)
      when :fn      then fn_special_form(tail, env)
      when :do      then do_special_form(tail, env)
      when :if      then if_special_form(tail, env)
      when :quote   then quote_special_form(tail, env)
      when :macro   then macro_special_form(tail, env)
      when :require then require_special_form(tail, env)
      else call_function(head, tail, env)
      end
    end

    def resolve_symbol(symbol, env)
      env.fetch(symbol)
    rescue KeyError
      raise NameError, "#{symbol} is not present in this context"
    end

    def call_function(symbol, args, env)
      fn = eval(symbol, env)

      case fn
      when Macro then eval(fn.(*args), env)
      else fn.(*args.map { |form| eval(form, env) })
      end
    end

    def def_special_form(form, env)
      key, value = form
      fail ArgumentError, "you can only def symbols" unless Symbol === key
      env[key] = eval(value, env)
    end

    def fn_special_form(form, env)
      params, func = form
      Fn.new(params, func, env)
    end

    def do_special_form(form, env)
      form.map { |form| eval(form, env) }.last
    end

    def if_special_form(form, env)
      conditional, true_form, false_form = form
      eval(conditional, env) ? eval(true_form, env) : eval(false_form, env)
    end

    def quote_special_form(form, _)
      form.first
    end

    def macro_special_form(form, env)
      params, func = form
      Macro.new(params, func, env)
    end

    def require_special_form(form, env)
      path = form.first
      Lasp::execute_file(File.expand_path(path, __dir__), env)
    end
  end
end
