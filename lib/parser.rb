module Lasp
  class Parser
    def self.parse(program)
      read_tokens(tokenize(program))
    end

    def self.read_tokens(tokens)
      token = tokens.shift

      if token == "("
        form = []
        while tokens.first != ")"
          form << read_tokens(tokens)
        end
        form
      else
        atom(token)
      end
    end

    def self.tokenize(string)
      string
        .gsub("(", " ( ")
        .gsub(")", " ) ")
        .split
    end

    def self.atom(token)
      case token
      when /\A\d+\z/ then Integer(token)
      else token.to_sym
      end
    end
  end
end
