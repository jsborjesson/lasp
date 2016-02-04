require "lasp/fn"

module Lasp
  class Macro < Fn
    # All that's needed is the type marker to let eval
    # know to pass in the arguments unevaluated.
  end
end
