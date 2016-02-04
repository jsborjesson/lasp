require "lasp/version"
require "lasp/eval"
require "lasp/parser"

module Lasp
  STDLIB_PATH = File.expand_path("../lasp/stdlib.lasp", __FILE__)

  module_function

  def execute_file(path)
    execute("(do #{File.read(path)})")
  end

  def execute(program, env = global_env)
    Lasp::eval(Parser.new.parse(program), env)
  end

  def load_stdlib!
    Lasp::execute_file(STDLIB_PATH)
  end
end
