module Lasp
  module Parameters
    def self.new(params)
      if params.include?(:&)
        RestParameters.new(params)
      else
        FixedParameters.new(params)
      end
    end

    class FixedParameters
      attr_reader :parameter_list

      def initialize(parameter_list)
        @parameter_list = parameter_list
        valid_signature!
      end

      def to_h(args)
        enforce_arity!(args)
        Hash[parameter_list.zip(args)]
      end

      def to_s
        "(" + parameter_list.join(" ") + ")"
      end

      private

      def enforce_arity!(args)
        if args.count != arity
          fail ArgumentError, "wrong number of arguments (#{args.count} for #{arity})"
        end
      end

      def valid_signature!
        if duplicate_parameter?
          fail SyntaxError, "Parameter names have to be unique. a is used more than once"
        end
      end

      def duplicate_parameter?
        parameter_list.uniq.length != parameter_list.length
      end

      def arity
        parameter_list.count
      end
    end

    class RestParameters < FixedParameters
      def to_h(args)
        enforce_arity!(args)

        ordered = parameter_list[0, minimum_arguments]
        rest    = parameter_list.last

        env = ordered.zip(args.take(ordered.length))
        env << [ rest, args.drop(ordered.length) ]

        Hash[env]
      end

      private

      def valid_signature!
        if multiple_rest_arguments? || ampersand_not_second_to_last?
          fail SyntaxError, "Rest-arguments may only be used once, at the end, with a single binding."
        end
        super
      end

      def multiple_rest_arguments?
        parameter_list.select { |b| b == :& }.length > 1
      end

      def ampersand_not_second_to_last?
        parameter_list.find_index(:&) != minimum_arguments
      end

      def minimum_arguments
        parameter_list.count - 2
      end

      def enforce_arity!(args)
        if args.count < minimum_arguments
          fail ArgumentError, "wrong number of arguments (#{args.count} for #{minimum_arguments}+)"
        end
      end
    end

  end
end