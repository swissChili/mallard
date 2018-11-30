=======
Mallard
=======

Mallard is a high level, interpreted, functional scripting language written in Crystal.
Mallard programs use the extension ``.mlrd``.

Preview
-------
::
    fib n ->
        match
            n <= 1 ->
                1
            true -> fib( n - 1) + fib( n - 2)
    main args ->
        puts "Received" len <| args "arguments"
        match
            len args > 1 ->
                puts "Fib: " fib args[1]


Implementation
--------------
Currently nothing works. Once I make stuff work I will add instructions for doing things
with Mallard programs.