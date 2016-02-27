require "lasp/params"

module Lasp
  class VariadicParams < Params
    def with_args(args)
      super.merge(rest_args(args))
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

    def rest_args(args)
      { param_list.last => args.drop(length) }
    end
  end
end
