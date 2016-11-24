require "lasp/errors"
require "lasp/params"
require "lasp/variadic_params"

module Lasp
  class ParamsBuilder
    def self.build(param_list)
      new(param_list).build
    end

    def initialize(param_list)
      @param_list = param_list
    end

    def build
      validate_params!
      params_object
    end

    private

    attr_reader :param_list

    def params_object
      if variadic?
        VariadicParams.new(param_list)
      else
        Params.new(param_list)
      end
    end

    def validate_params!
      validate_list!
      validate_single_ampersand!
      validate_single_rest_parameter!
      validate_unique_parameter_names!
    end

    def variadic?
      param_list.include?(:&)
    end

    def validate_list!
      fail SyntaxError, "parameters must be a list" unless param_list.is_a?(Array)
    end

    def validate_unique_parameter_names!
      accepted_params = param_list.reject { |p| p == :_ }

      unless accepted_params.uniq.length == accepted_params.length
        fail SyntaxError, "parameter names must be unique (except for _)"
      end
    end

    def validate_single_ampersand!
      invalid_rest_argument_usage! unless param_list.count { |p| p == :& } <= 1
    end

    def validate_single_rest_parameter!
      invalid_rest_argument_usage! if variadic? && param_list[-2] != :&
    end

    def invalid_rest_argument_usage!
      fail SyntaxError, "rest-arguments may only be used once, at the end, with a single binding"
    end
  end
end
