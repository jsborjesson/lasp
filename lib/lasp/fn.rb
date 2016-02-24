require "lasp/interpreter"
require "lasp/params"
require "lasp/errors"

module Lasp
  class Fn
    attr_reader :params, :body, :env

    def initialize(params, body, env)
      @params = ParamsBuilder.build(params)
      @body   = body
      @env    = env
    end

    def call(*args)
      Interpreter.eval(body, env_with_args(args))
    end

    def inspect
      class_name = self.class.name.split("::").last
      "#<#{class_name} #{params}>"
    end

    private

    def env_with_args(args)
      env.merge(params.with_args(args))
    end
  end
end
