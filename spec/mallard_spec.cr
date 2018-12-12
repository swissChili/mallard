require "./spec_helper"

describe Mallard do

    it "lex" do
        Mallard::Lexer.new.tokenize("let foo ->\n    bar\nfoo qux")
    end

    it "parse" do
        Mallard::Parser.new.parse(Mallard::Lexer.new.tokenize("let foo ->\n    bar\nfoo qux"))
    end

end
