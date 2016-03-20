require "lasp/version"
require "lasp/env"
require "lasp/parser"
require "lasp/interpreter"
require "lasp/corelib"
require "lasp/ext"

module Lasp
  STDLIB_PATH = File.expand_path("../lasp/stdlib.lasp", __FILE__)

  module_function

  def execute(program, env = env_with_corelib)
    Interpreter.eval(Parser.parse(program), env)
  end

  def execute_file(path, env = env_with_corelib)
    env[:__FILE__] = path
    result = execute("(do #{File.read(path)})", env)
    env[:__FILE__] = nil
    result
  end

  def env_with_corelib
    Env.new(CORELIB.dup)
  end

  def env_with_stdlib
    env_with_corelib.tap do |env|
      Lasp.execute_file(STDLIB_PATH, env)
    end
  end
end
