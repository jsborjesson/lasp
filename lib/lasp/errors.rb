module Lasp
  LaspError     = Class.new(StandardError)
  ArgumentError = Class.new(LaspError)
  NameError     = Class.new(LaspError)
  SyntaxError   = Class.new(LaspError)
end
