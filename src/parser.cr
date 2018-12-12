require "./token.cr"

module Mallard

	class Node
		@type : Symbol | String | Int32
		@args : Array(Tree | Int32 | String | Symbol | Node)
		def initialize(t, a = [] of Tree | Int32 | String | Symbol | Node)
			@type = t
			@args = a
		end
		def type
			@type
		end
		def type=(t)
			@type = t
		end
		def args
			@args
		end
		def args=(a)
	    	@args = a
		end
		def [](n)
			@args[n]
		end
		def []=(i, n)
			@args[i] = n
		end
		def push(a)
			@args.push(a)
		end

		def push(a : Token)
			self.push(a.value)
		end
	end

	class Tree

		def initialize
			@nodes = [] of Node
		end

		def nodes
			@nodes
		end

		def [](n)
			@nodes[n]
		end

		def []=(i, n)
			@nodes[i] = n
		end

		def push(node : Node)
			@nodes.push(node)
		end

		def pop
			@nodes.pop
		end

	end

	class Parser

		def parse(tokens : Array(Token), indent=0)
			indx = 0
			tree = Tree.new
			tree.push(Node.new(:UNDEFINED))
			while indx < tokens.size
				t  = tokens[indx]
				puts "TOKEN : #{t.type} : #{t.value}"
				# need to inc here because new indx is used later

				indx += 1

				if t.type == :LET

					tree[-1].type = :LET

				elsif t.type == :IDENTIFIER

					if tree[-1].type == :UNDEFINED
						tree[-1].type = t.value
					else
						tree[-1].push(t.value)
					end

				elsif t.type == :NUMBER
					tree[-1].push(t.value)
				elsif t.type == :ASSIGNMENT
					# matches =
					if tree[-1].type == :LET || tree[-1].type == :ATOM
						# parse to the end of the line to a new node
						line = parseCommand(tokens[indx..-1])
						if !line.nil?
							tree[-1].push(line)
						end
					end
				elsif t.type == :NEWLINE
					tree.push(Node.new(:UNDEFINED))
				elsif t.type == :INDENT
					block = Parser.new.parse(tokens[indx..-1], t.value)
					# block is [parsed tree, end index]
					indx += block[1]
					tree[-1].push(block[0])
				elsif t.type == :DEDENT
					case { t.value, indent }
					when { Int32, Int32 }
						if t.value.as(Int32) <= indent
							return tree, indx
						end
					end
				end

			end

			return tree, indx

		end

		def parseCommand(tokens : Array(Token))
			if tokens.size < 1 && tokens[0].type == :IDENTIFIER
				n = Node.new(tokens[0].value)
				tokens.each do |token|
					if token.type != :NEWLINE
						n.push(token)
					else
						return n
					end
				end
			end
		end

	end

end
