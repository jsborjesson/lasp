require "strscan"

class Lexer
  TOKENS = [
    /\(|\)/,          # parens
    /'/,              # quote
    /"(\\"|[^"])*"/,  # string literal
    /[^\s)]+/,        # any non-whitespace character excluding )
  ]

  def self.tokenize(program)
    new(program).tokenize
  end

  def initialize(program)
    @scanner = StringScanner.new(program)
  end

  def tokenize
    tokens = []
    while (token = read_token)
      tokens << token
    end
    tokens
  end

  private

  attr_reader :scanner

  def read_token
    scanner.skip(/\s+/)
    return if scanner.eos?

    TOKENS.each do |token|
      return scanner.scan(token) if scanner.match?(token)
    end
  end
end
