require "./lib/corelib"

module Lasp
  module_function

  def global_env
    @global_env ||= {}.merge(CORELIB)
  end
end
