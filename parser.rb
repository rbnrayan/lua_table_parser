require_relative 'lexer'

class Parser
  attr_reader :tokens
  
  def initialize(source)
    @tokens = Lexer.new(source).tokenize
  end

  def parse
    if peek_next_token.kind == :IDENTIFIER
      { parse_token(:IDENTIFIER).value.to_sym => parse_table }
    else
      parse_table
    end
  end

  private

  def tokens=(tokens)
    @tokens = tokens
  end
  
  def consume_token(n = 1)
    token = tokens.first
    self.tokens = tokens.drop(n)
    token
  end

  def parse_token(kind)
    token = consume_token
    if kind.is_a?(Array)
      raise ParserError, "Expected one of the following: #{kind} token, found :#{token.kind} => `#{token.value}`" unless kind.include?(token.kind)
    else
      raise ParserError, "Expected: :#{kind} token, found :#{token.kind} => `#{token.value}`" unless token.kind == kind
    end
    token
  end

  def peek_next_token
    tokens.first
  end

  def parse_table
    parse_token(:OPEN_CURLY)

    table = [{}]

    entry = parse_entry
    if entry.is_a?(Hash)
      table.first.merge!(entry)
    else
      table.push(entry)
    end

    next_token = parse_token([:COMMA, :CLOSE_CURLY])

    while next_token.kind == :COMMA
      entry = parse_entry
      if entry.is_a?(Hash)
        table.first.merge!(entry)
      else
        table.push(entry)
      end
      next_token = parse_token([:COMMA, :CLOSE_CURLY])
    end

    table.reject { |item| item.empty? }
  end

  def parse_entry
    return parse_token([:STRING, :NUMBER]).value unless peek_next_token.kind == :IDENTIFIER

    entry = {}

    ident = parse_token(:IDENTIFIER)
    parse_token(:EQUAL)
    val = peek_next_token

    if val.kind == :OPEN_CURLY
      entry.store(ident.value.to_sym, parse_table)
    else
      entry.store(ident.value.to_sym, parse_token([:STRING, :NUMBER]).value)
    end

    entry
  end
end

class ParserError < StandardError; end
