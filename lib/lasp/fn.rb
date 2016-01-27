require "lasp/eval"
require "lasp/parameters"
require "lasp/errors"

module Lasp
  class Fn
    attr_reader :parameters, :body, :env

    def initialize(parameters, body, env)
      @parameters = Parameters.new(parameters)
      @body       = body
      @env        = env
    end

    def call(*args)
      Lasp::eval(body, env_with_args(args))
    end

    def inspect
      "#<Fn #{parameters}>"
    end

    private

    def env_with_args(args)
      env.merge(parameters.to_h(args))
    end
  end
end
