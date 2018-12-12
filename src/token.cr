module Mallard
	class Token
        @type : Symbol
        @value : Int32 | String | Symbol
        def initialize(t, value=0)
            @type  = t
            @value = value
        end
        def <=(other)
            false
        end
        def type
        	@type
        end
        def value
        	@value
        end
    end
end
