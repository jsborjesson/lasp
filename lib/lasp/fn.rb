require "lasp/interpreter"
require "lasp/params_builder"
require "lasp/errors"

module Lasp
  class Fn
    attr_reader :params, :body, :env, :name

    def initialize(params, body, env)
      @params = ParamsBuilder.build(params)
      @body   = body
      @env    = env
    end

    def call(*args)
      Interpreter.eval(body, env_with_args(args))
    end

    def inspect
      "#<#{ [class_name, name, params].compact.join(" ") }>"
    end

    def name=(new_name)
      @name = new_name if name.nil?
    end

    private

    def env_with_args(args)
      env.merge(params.with_args(args))
    end

    def class_name
      self.class.name.split("::").last
    end
  end
end
