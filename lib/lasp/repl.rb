require "lasp"
require "readline"

module Lasp
  module_function

  def repl
    trap("SIGINT") { puts "\n\nBye!"; exit }

    puts "((( Läsp v#{Lasp::VERSION} REPL (ctrl+c to exit) )))\n\n"
    loop do
      begin
        history = true
        input   = Readline.readline("lasp> ", history).to_s
        input   = autoclose_parentheses(input)
        result  = Lasp::execute(input)
        puts "   => #{result.inspect}"
      rescue
        puts "   !> #{$!}"
      end
    end
  end

  def autoclose_parentheses(input)
    num_opens  = input.chars.select { |c| c == "(" }.count
    num_closes = input.chars.select { |c| c == ")" }.count

    if num_opens > num_closes
      missing_closes = num_opens - num_closes

      puts "   ?> Appending #{missing_closes} missing closing parentheses:"
      corrected_input = input + (")" * missing_closes)
      puts "   ?> #{corrected_input}"

      corrected_input
    else
      input
    end
  end
end
