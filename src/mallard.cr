require "./lexer.cr"
require "./parser.cr"
require "./debug.cr"

# TODO: Write documentation for `Mallard`
module Mallard
    VERSION = "0.1.0"
  	tokens = Mallard::Lexer.new.tokenize(File.read("demo.mal"))
  	tree = Mallard::Parser.new.parse(tokens)

    debugTree tree[0], tree[1]
end
