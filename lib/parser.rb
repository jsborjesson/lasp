module Lasp
  module_function

  def parse(program)
    read_tokens(tokenize(program))
  end

  def read_tokens(tokens)
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

  def tokenize(string)
    string
      .gsub("(", " ( ")
      .gsub(")", " ) ")
      .split
  end

  def atom(token)
    case token
    when /\A\d+\z/ then Integer(token)
    else token.to_sym
    end
  end
end
