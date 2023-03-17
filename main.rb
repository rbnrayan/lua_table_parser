require_relative 'lexer'

sample = '{ name = "sh", cmd = { "/bin/sh" } }'

lexer = Lexer.new(sample)
p lexer.tokenize
