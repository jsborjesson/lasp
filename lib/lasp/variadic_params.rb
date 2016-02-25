require "lasp/params"

module Lasp
  class VariadicParams < Params
    def with_args(args)
      rest_args = { rest => args.drop(length) }
      super.merge(rest_args)
    end

    private

    def fixed_params
      param_list.take_while { |p| p != :& }
    end

    def arity
      super + "+"
    end

    def matches_arity?(num_args)
      num_args >= length
    end

    def rest
      param_list.last
    end
  end
end
