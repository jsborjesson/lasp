require "lasp"
require "lasp/parser"
require "readline"

module Lasp
  class Repl
    def self.run
      new.run
    end

    def run
      trap("SIGINT") { puts "\n\nBye!"; exit }

      puts "((( Läsp v#{Lasp::VERSION} REPL (ctrl+c to exit) )))\n\n"
      loop do
        begin
          history = true
          input   = Readline.readline(prompt, history).to_s
          input   = autoclose_parentheses(input)
          result  = Lasp::execute(input)
          print_result(result)
        rescue => error
          print_error(error)
        end
      end
    end

    private

    def autoclose_parentheses(input)
      tokens     = Parser.new.tokenize(input)
      num_opens  = tokens.select { |t| t == "(" }.count
      num_closes = tokens.select { |t| t == ")" }.count

      if num_opens > num_closes
        missing_closes = num_opens - num_closes

        print_info "Appending #{missing_closes} missing closing parentheses:"
        corrected_input = input + (")" * missing_closes)
        print_info "#{corrected_input}"

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
