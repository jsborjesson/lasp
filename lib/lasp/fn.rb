require "lasp/eval"
require "lasp/params"
require "lasp/errors"

module Lasp
  class Fn
    attr_reader :params, :body, :env

    def initialize(params, body, env)
      @params = Params.new(params)
      @body   = body
      @env    = env
    end

    def call(*args)
      Lasp::eval(body, env_with_args(args))
    end

    def inspect
      class_name = self.class.name.split("::").last
      "#<#{class_name} #{params}>"
    end

    private

    def env_with_args(args)
      enforce_arity!(args)

      params_with_args = params
                           .ordered
                           .zip(args.take(params.length))
                           .to_h

      if params.variadic?
        params_with_args[params.rest] = args.drop(params.length)
      end

      env.merge(params_with_args)
    end

    def enforce_arity!(args)
      wrong_number_of_args!(args) unless params.matches_arity?(args.length)
    end

    def wrong_number_of_args!(args)
      fail ArgumentError, "wrong number of arguments (#{args.length} for #{params.arity})"
    end
  end
end
