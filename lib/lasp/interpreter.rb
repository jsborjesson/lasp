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
      resolve_ruby_constant(symbol)
    end

    def resolve_ruby_constant(symbol)
      Object.const_get(symbol.to_s.gsub("/", "::"))
    rescue ::NameError
      raise NameError, "#{symbol} is not present in this context"
    end

    def call_function(symbol, args, env)
      fn = eval(symbol, env)

      case fn
      when Macro then eval(fn.call(*args), env)
      else fn.call(*args.map { |arg| eval(arg, env) })
      end
    end

    def def_special_form(form, env)
      key, value = form
      fail ArgumentError, "you can only def symbols" unless key.is_a?(Symbol)
      env[key] = eval(value, env)
    end

    def fn_special_form(form, env)
      params, func = form
      Fn.new(params, func, env)
    end

    def do_special_form(forms, env)
      forms.map { |form| eval(form, env) }.last
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
      require_path, is_relative = form

      require_root  = is_relative ? File.dirname(env.fetch(:__FILE__)) : Dir.pwd
      absolute_path = File.expand_path(require_path, require_root)

      Lasp.execute_file(absolute_path, env)
    end
  end
end
