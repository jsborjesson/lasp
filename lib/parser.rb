module Lasp
  module_function

  def parse(program)
    build_ast(tokenize(program))
  end

  def build_ast(tokens)
    token = tokens.shift

    if token == "("
      form = []
      while tokens.first != ")"
        form << build_ast(tokens)
      end
      tokens.shift
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
    when /\Atrue|false\z/ then token == "true"
    when /\A\d+\z/        then Integer(token)
    when /\A\d+.\d+\z/    then Float(token)
    else token.to_sym
    end
  end
end
