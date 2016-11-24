require "forwardable"

module Lasp
  class Env
    extend Forwardable

    def_delegators :@env, :fetch, :[]=

    def initialize(env = {})
      @env = env
    end

    def merge(hash)
      Env.new(@env.merge(hash))
    end
  end
end
