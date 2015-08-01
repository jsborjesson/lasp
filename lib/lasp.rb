require "lasp/version"
require "lasp/eval"

module Lasp
  module_function

  def load_stdlib!
    Lasp::execute_file(File.expand_path("../lasp/stdlib.lasp", __FILE__))
  end
end
