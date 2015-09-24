require "lasp"
require "readline"

module Lasp
  module_function

  def repl
    trap("SIGINT") { puts "\n\nBye!"; exit }

    puts "((( Läsp v#{Lasp::VERSION} REPL (ctrl+c to exit) )))\n\n"
    loop do
      begin
        input =  Readline.readline("lasp> ", true)
        result = Lasp::execute(input)
        puts "   => #{result.inspect}"
      rescue
        puts "   *> #{$!}"
      end
    end
  end
end
