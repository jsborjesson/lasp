require "./lib/core_lib"

module Lasp
  module_function

  def global_env
    @global_env ||= {}.merge(CORE_LIB)
  end
end
