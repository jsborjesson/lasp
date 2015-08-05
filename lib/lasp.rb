require "lasp/version"
require "lasp/eval"

module Lasp
  STDLIB_PATH = File.expand_path("../lasp/stdlib.lasp", __FILE__)

  module_function

  def execute_file(path)
    execute(File.read(path))
  end

  def execute(program, env = global_env)
    Lasp::eval(Lasp::parse(program), env)
  end

  def load_stdlib!
    Lasp::execute_file(STDLIB_PATH)
  end
end
