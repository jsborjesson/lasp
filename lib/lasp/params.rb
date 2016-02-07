require "lasp/errors"

module Lasp
  class Params
    attr_reader :param_list

    def initialize(param_list)
      @param_list = param_list

      validate_params!
    end

    def ordered
      param_list.take_while { |p| p != :& }
    end

    def rest
      unless variadic?
        fail LaspError, "a non-variadic function does not have rest-arguments"
      end
      param_list.last
    end

    def variadic?
      param_list.include?(:&)
    end

    def arity
      ordered.length.to_s + (variadic? ? "+" : "")
    end

    def matches_arity?(num_args)
      if variadic?
        num_args >= length
      else
        num_args == length
      end
    end

    def length
      ordered.length
    end

    def to_s
      "(" + param_list.join(" ") + ")"
    end

    private

    def validate_params!
      validate_single_ampersand!
      validate_single_rest_parameter!
      validate_unique_parameter_names!
    end

    def validate_unique_parameter_names!
      unless param_list.uniq.length == param_list.length
        fail SyntaxError, "parameter names have to be unique."
      end
    end

    def validate_single_ampersand!
      invalid_rest_argument_usage! unless param_list.select { |p| p == :& }.length <= 1
    end

    def validate_single_rest_parameter!
      invalid_rest_argument_usage! if variadic? && param_list[-2] != :&
    end

    def invalid_rest_argument_usage!
      fail SyntaxError, "rest-arguments may only be used once, at the end, with a single binding"
    end
  end
end
