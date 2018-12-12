require "./token.cr"

module Mallard

    class Lexer
        # the keywords reserved in the language:
        KEYWORDS = {
            "let"   => :LET,   # The standard immutable variable type
            "atom"  => :ATOM,  # an atomic value, like `let` but mutable
            "data"  => :DATA,  # a data type, imagine struct + typedef
            "match" => :MATCH, # like if but better
            "true"  => :TRUE,  # boolean, evaluates to 1
            "false" => :FALSE, # boolean, evaluates to 0
            "nil"   => :NIL    # nil: variables default to this
        }

        OPERATORS = {
            "!=" => :NOT_EQUAL,
            "==" => :EQUAL,
            "||" => :BINARY_OR,
            "&&" => :BINARY_AND,
            "<=" => :LESS_OR_EQ,
            ">=" => :GREATOR_OR_EQ,
            "="  => :ASSIGNMENT
        }

        def tokenize(code : String)
            # remove trailing whitespace
            code = code.chomp
            # the parsed tokens
            tokens = [] of Token

            # size of last indent
            current_indent = 0
            # list of indents used
            indent_stack = [] of Int32

            i = 0
            while i < code.size
                # the code remaining to parse
                chunk = code[i..-1]

                # start matching tokens to see what works
                if newline = /^(\n+)/.match(chunk)
                    s = newline[1].size
                    puts "NEWLINE #{s}"
                    tokens << Token.new(:NEWLINE, s)
                    i += s
                # an identifier. lowercase chars
                elsif identifier = /^([a-z]\w*)/.match(chunk)
                    identifier = identifier[0]
                    if KEYWORDS.keys.includes?(identifier)
                        tokens << Token.new(KEYWORDS[identifier])
                    else
                        tokens << Token.new(:IDENTIFIER, identifier)
                    end

                    i += identifier.size

                # a number, only ints supported so far
                elsif number = /^([0-9]+)/.match(chunk)
                    number = number[1]

                    tokens << Token.new(:NUMBER, number.to_i)
                    i += number.size
                # quote encapsulated string
                elsif string = /^"([^"])*"/.match(chunk)
                    string = string[0]

                    tokens << Token.new(:STRING, string[1...-1])
                    i += string.size
                # new scope ->
                #    and indent
                elsif indent = /^->\n(\s+)/.match(chunk)
                    indent_size = indent[1].size
                    if indent_size <= current_indent
                        puts "INDENT_SIZE > CURENT", indent_size, current_indent
                        raise "Invalid indentation"
                    end
                    current_indent = indent_size
                    indent_stack.push(current_indent)
                    tokens << Token.new(:INDENT, indent_size)
                    i += indent_size + 3

                # match dedent
                elsif indent = /^\n(\s*)/.match(chunk)
                    indent_size = indent[1].size
                    if indent_size == current_indent
                        tokens << Token.new(:NEWLINE, "\n")

                    elsif indent_size < current_indent

                        while indent_size < current_indent
                            indent_stack.pop
                            if indent_stack.size > 0
                                current_indent = indent_stack[-1]
                            else
                                current_indent = 0
                            end

                        end
                        tokens << Token.new(:DEDENT, indent_size)
                        tokens << Token.new(:NEWLINE)
                    end
                    i += indent_size + 1

                elsif operator = /^(\|\||&&|==|!=|<=|>=|=)/.match(chunk)
                    operator = operator[1]
                    tokens << Token.new(:OPERATOR, OPERATORS[operator])
                    i += operator.size

                elsif /^\s/.match(chunk)
                    i += 1
                else
                    value = chunk[0, 1]
                    puts "ELSE"
                    tokens << Token.new(:VALUE, value)
                    i += 1
                end
            end

            return tokens
        end
    end
end
