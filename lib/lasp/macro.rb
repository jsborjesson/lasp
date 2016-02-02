require "lasp/fn"

module Lasp
  class Macro < Fn
    def inspect
      "#<Macro #{params}>"
    end
  end
end
