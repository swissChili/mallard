require "./parser.cr"

def debugTree(tree : Mallard::Tree, index=0) # index is useless

    tree.nodes.each do |node|

        if node.args.size > 0
            puts "< #{node.type} : ["
            node.args.each do |arg|
                # arg is Tree | Int32 | String | Symbol
                case {arg}
                when {Mallard::Tree}
                    debugTree arg
                when {Int32}
                    puts arg
                when {String}
                    puts "\"#{arg}\""
                when Symbol
                    puts "@#{arg}"
                end
            end
            puts "] >"
        else
            puts "< #{node.type} : [] >"
        end

    end

end
