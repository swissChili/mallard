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

    def tokenize(code : String)
        # remove trailing whitespace
        code = code.chomp
        # the parsed tokens
        tokens = [] of Array(Symbol|String) | Array(Symbol|Int32) | Array(Symbol)
        
        # size of last indent
        current_indent = 0
        # list of indents used
        indent_stack = [] of Int32

        i = 0
        while i < code.size
            # the code remaining to parse
            chunk = code[i..-1]

            # start matching tokens to see what works
            # an identifier. lowercase chars
            if identifier = /^([a-z]\w*)/.match(chunk)
                identifier = identifier[0]
                if KEYWORDS.keys.includes?(identifier)
                    tokens << [KEYWORDS[identifier]]
                else
                    tokens << [:IDENTIFIER, identifier]
                end

                i += identifier.size
            # a number, only ints supported so far
            elsif number = /^([0-9]+)/.match(chunk)
                number = number[1]

                tokens << [:NUMBER, number.to_i]
                i += number.size
            # quote encapsulated string
            elsif string = /^"([^"])*"/.match(chunk)
                string = string[0]

                tokens << [:STRING, string[1...-1]]
                i += string.size
            # new scope. ->
            #    and indent
            elsif indent = /^->\n(\s+)/.match(chunk)
                indent_size = indent[1].size
                if indent_size <= current_indent
                    puts "INDENT_SIZE > CURENT", indent_size, current_indent
                    raise "Invalid indentation"
                end
                current_indent = indent_size
                indent_stack.push(current_indent)
                tokens << [:INDENT, indent_size]
                i += indent_size + 3

            # match dedent
            elsif indent = /^\n(\s*)/.match(chunk)
                indent_size = indent[1].size
                if indent_size == current_indent
                    tokens << [:NEWLINE, "\n"]

                elsif indent_size < current_indent

                    while indent_size < current_indent
                        indent_stack.pop
                        if indent_stack.size > 0
                            current_indent = indent_stack[-1]
                        else
                            current_indent = 0
                        end
                        
                    end
                    tokens << [:DEDENT, indent_size]
                    tokens << [:NEWLINE, "\n"]
                end
                i += indent_size + 1

            elsif operator = /^(\|\||&&|==|!=|<=|>=)/.match(chunk)
                operator = operator[1]
                tokens << [:OPERATOR, operator]
                i += operator.size
            elsif /^\s/.match(chunk)
                i += 1
            else
                value = chunk[0, 1]
                tokens << [:VALUE, value]
                i += 1
            end
        end

        return tokens
    end
end
