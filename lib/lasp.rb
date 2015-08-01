require "lasp/version"
require "lasp/eval"

module Lasp
  module_function

  def execute_file(path)
    execute(File.read(path))
  end

  def execute(program, env = global_env)
    Lasp::eval(Lasp::parse(program), env)
  end

  def load_stdlib!
    Lasp::execute_file(File.expand_path("../lasp/stdlib.lasp", __FILE__))
  end
end
