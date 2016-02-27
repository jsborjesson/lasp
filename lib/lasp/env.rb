require "forwardable"

module Lasp
  class Env
    extend Forwardable

    def_delegators :@env, :fetch, :merge, :[]=

    def initialize(env = {})
      @env = env
    end
  end
end
