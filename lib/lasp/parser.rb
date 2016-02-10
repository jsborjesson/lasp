module Lasp
  class Parser
    def self.parse(program)
      new.parse(program)
    end

    def parse(program)
      build_ast(tokenize(sanitize(program)))
    end

    def tokenize(string)
      string.scan(/(?:(?:[^\s"()']|"[^"]*")+|[()'])/)
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
      when /"(.*)"/        then String($1)
      when /:(\w+)/        then String($1) # Symbol style strings are actually just strings
      else token.to_sym
      end
    end

    def sanitize(string)
      string.gsub(/;.*$/, "")
    end
  end
end
