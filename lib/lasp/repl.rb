require "lasp"
require "lasp/lexer"
require "readline"

module Lasp
  class Repl
    def self.run
      new.run
    end

    def run
      # Exit on Ctrl+C
      trap("SIGINT") do
        puts "\n\nBye!"
        exit
      end

      env = Lasp.env_with_stdlib

      puts "((( Läsp v#{Lasp::VERSION} REPL (ctrl+c to exit) )))\n\n"
      loop do
        begin
          history = true
          input   = Readline.readline(prompt, history).to_s
          input   = autoclose_parentheses(input)
          result  = Lasp.execute(input, env)
          print_result(result)
        rescue => error
          print_error(error)
        end
      end
    end

    private

    def autoclose_parentheses(input)
      tokens     = Lexer.tokenize(input)
      num_opens  = tokens.count { |t| t == "(" }
      num_closes = tokens.count { |t| t == ")" }

      if num_opens > num_closes
        missing_closes = num_opens - num_closes

        print_info "Appending #{missing_closes} missing closing parentheses:"
        corrected_input = input + (")" * missing_closes)
        print_info corrected_input.to_s

        corrected_input
      else
        input
      end
    end

    def prompt
      "lasp> "
    end

    def print_error(error)
      puts "   !> #{error.class}: #{error.message}"
    end

    def print_info(message)
      puts "   ?> #{message}"
    end

    def print_result(result)
      puts "   => #{result.inspect}"
    end
  end
end
