require "lasp/errors"

module Lasp
  class ParamsBuilder
    def self.build(param_list)
      new(param_list).build
    end

    def initialize(param_list)
      @param_list = param_list
    end

    def build
      validate_params!
      params_object
    end

    private

    attr_reader :param_list

    def params_object
      if variadic?
        VariadicParams.new(param_list)
      else
        Params.new(param_list)
      end
    end

    def validate_params!
      validate_list!
      validate_single_ampersand!
      validate_single_rest_parameter!
      validate_unique_parameter_names!
    end

    def variadic?
      param_list.include?(:&)
    end

    def validate_list!
      unless Array === param_list
        fail SyntaxError, "parameters must be a list"
      end
    end

    def validate_unique_parameter_names!
      unless param_list.uniq.length == param_list.length
        fail SyntaxError, "parameter names have to be unique"
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

  class Params
    attr_reader :param_list

    def initialize(param_list)
      @param_list = param_list
    end

    def ordered
      param_list
    end

    def arity
      ordered.length.to_s
    end

    def matches_arity?(num_args)
      num_args == length
    end

    def length
      ordered.length
    end

    def to_s
      "(" + param_list.join(" ") + ")"
    end

    def with_args(args)
      enforce_arity!(args)

      ordered.zip(args.take(length)).to_h
    end

    private

    def enforce_arity!(args)
      wrong_number_of_args!(args) unless matches_arity?(args.length)
    end

    def wrong_number_of_args!(args)
      fail ArgumentError, "wrong number of arguments (#{args.length} for #{arity})"
    end
  end

  class VariadicParams < Params
    def with_args(args)
      rest_args = { rest => args.drop(length) }
      super.merge(rest_args)
    end

    def ordered
      param_list.take_while { |p| p != :& }
    end

    def arity
      super + "+"
    end

    def matches_arity?(num_args)
      num_args >= length
    end

    private

    def rest
      param_list.last
    end
  end
end
