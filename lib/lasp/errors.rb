module Lasp
  LaspError     = Class.new(StandardError)
  SyntaxError   = Class.new(LaspError)
  ArgumentError = Class.new(LaspError)
end
