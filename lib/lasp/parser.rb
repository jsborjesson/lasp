require "lasp/lexer"

module Lasp
  class Parser
    ESCAPE_CHARACTERS = {
      '\n'   => "\n",
      '\t'   => "\t",
      '\\\\' => "\\",
      '\"'   => "\"",
    }.freeze

    def self.parse(program)
      new.parse(program)
    end

    def parse(program)
      build_ast(tokenize(program))
    end

    def tokenize(program)
      Lexer.tokenize(program)
    end

    private

    def build_ast(tokens)
      return if tokens.empty?
      token = tokens.shift

      case token
      when "(" then form(tokens)
      when "'" then quote(tokens)
      when "." then dot(tokens)
      else atom(token)
      end
    end

    def form(tokens)
      form = []
      form << build_ast(tokens) while tokens.first != ")"
      tokens.shift
      form
    end

    def quote(tokens)
      [:quote] << build_ast(tokens)
    end

    def dot(tokens)
      method = tokens.shift
      tokens.unshift(":" + method)
      :send
    end

    def atom(token)
      case token
      when "true"          then true
      when "false"         then false
      when "nil"           then nil
      when /\A-?\d+\z/     then Integer(token)
      when /\A-?\d+.\d+\z/ then Float(token)
      when /"(.*)"/        then String(unescape(Regexp.last_match(1)))
      when /:([^\s]+)/     then String(Regexp.last_match(1)) # Symbol style strings are actually just strings
      else token.to_sym
      end
    end

    def unescape(string)
      string.gsub(/\\(.)/) { |match| ESCAPE_CHARACTERS.fetch(match, match[1]) }
    end
  end
end
