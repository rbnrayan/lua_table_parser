class Lexer
  attr_accessor :source

  def initialize(source)
    raise LexerError, 'ERROR: lexer source must be a string' unless source.is_a?(String)

    @source = source
  end

  def tokenize
    tokens = []
    current_token = next_token

    until current_token.kind == :END
      tokens << current_token
      current_token = next_token
    end

    tokens.reject { |token| token.kind == :WHITESPACE }
  end

  def next_token
    return Token.new(:END, nil) unless source.length >= 1

    next_char = source.slice(0, 1)
    self.source = source[1..]

    case next_char
    when '{'
      Token.new(:OPEN_CURLY, next_char)
    when '}'
      Token.new(:CLOSE_CURLY, next_char)
    when 'a'..'z', 'A'..'Z'
      ident = scan_identifier(next_char)
      self.source = source.chars.drop_while { |char| alpha?(char) }.join

      Token.new(:IDENTIFIER, ident)
    when '0'..'9'
      num = scan_number(next_char)
      self.source = source.chars.drop_while { |char| numeric?(char) }.join

      Token.new(:NUMBER, num)
    when ' ', "\n", "\t"
      source.lstrip!
      Token.new(:WHITESPACE, nil)
    when '"', "'"
      str = scan_string(next_char)
      self.source = source.chars.drop_while{ |char| char != next_char }.drop(1).join

      Token.new(:STRING, str)
    when '='
      Token.new(:EQUAL, next_char)
    when ','
      Token.new(:COMMA, next_char)
    else
      raise LexerError, "Unknown token starts with: #{next_char}"
    end
  end

  private

  def scan_identifier(current_char)
    source.chars.take_while { |char| alpha?(char) }.unshift(current_char).join
  end

  def scan_number(current_char)
    source.chars.take_while { |char| numeric?(char) }.unshift(current_char).join.to_i
  end

  def scan_string(current_char)
    source.chars.take_while { |char| char != current_char }.join
  end

  def alpha?(char)
    (('a'..'z').to_a + ('A'..'Z').to_a).include?(char)
  end

  def numeric?(char)
    ('0'..'9').to_a.include?(char)
  end
end

class LexerError < StandardError; end

Token = Struct.new(:kind, :value)
