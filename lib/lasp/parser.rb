require "lasp/lexer"

module Lasp
  class Parser
    ESCAPE_CHARACTERS = {
      '\n'   => "\n",
      '\t'   => "\t",
      '\\\\' => "\\",
      '\"'   => "\"",
    }

    def self.parse(program)
      new.parse(program)
    end

    def parse(program)
      build_ast(tokenize(sanitize(program)))
    end

    def tokenize(string)
      Lexer.tokenize(string)
    end

    private

    def build_ast(tokens)
      return if tokens.empty?
      token = tokens.shift

      case token
      when "(" then form(tokens)
      when "'" then quote(tokens)
      else atom(token)
      end
    end

    def form(tokens)
      form = []
      while tokens.first != ")"
        form << build_ast(tokens)
      end
      tokens.shift
      form
    end

    def quote(tokens)
      [:quote] << build_ast(tokens)
    end

    def atom(token)
      case token
      when "true"          then true
      when "false"         then false
      when "nil"           then nil
      when /\A-?\d+\z/     then Integer(token)
      when /\A-?\d+.\d+\z/ then Float(token)
      when /"(.*)"/        then String(unescape($1))
      when /:([^\s]+)/     then String($1) # Symbol style strings are actually just strings
      else token.to_sym
      end
    end

    def sanitize(string)
      string.gsub(/;.*$/, "")
    end

    def unescape(string)
      string.gsub(/\\./, ESCAPE_CHARACTERS)
    end
  end
end
