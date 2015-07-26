module Lasp
  module_function

  def parse(program)
    build_ast(tokenize(sanitize(program)))
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
    when "true"        then true
    when "false"       then false
    when "nil"         then nil
    when /\A\d+\z/     then Integer(token)
    when /\A\d+.\d+\z/ then Float(token)
    else token.to_sym
    end
  end

  def sanitize(string)
    string.gsub(/;.*$/, "")
  end
end
