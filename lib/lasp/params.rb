require "lasp/errors"

module Lasp
  class Params
    attr_reader :param_list

    def initialize(param_list)
      @param_list = param_list
    end

    def to_s
      "(" + param_list.join(" ") + ")"
    end

    def with_args(args)
      enforce_arity!(args)
      fixed_params.zip(args.take(length)).to_h
    end

    private

    def fixed_params
      param_list
    end

    def arity
      length.to_s
    end

    def matches_arity?(num_args)
      num_args == length
    end

    def length
      fixed_params.length
    end

    def enforce_arity!(args)
      wrong_number_of_args!(args) unless matches_arity?(args.length)
    end

    def wrong_number_of_args!(args)
      fail ArgumentError, "wrong number of arguments (#{args.length} for #{arity})"
    end
  end
end
