require "./lexer.cr"

# TODO: Write documentation for `Mallard`
module Mallard
    VERSION = "0.1.0"
    Lexer.new.tokenize(File.read("demo.mlrd")).each do |t|

    	puts t

    end
    # TODO: Put your code here
end
