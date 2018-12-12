=======
Mallard
=======

.. image:: https://api.travis-ci.org/swissChili/mallard.svg?branch=master

Mallard is a high level, interpreted, functional scripting language written in
Crystal. Mallard programs use the extension ``.mal``.

Building
--------

To build you will need an up-to-date version of the Crystal compiler, which
means no building for windows.

::

    $ shards build
    $ bin/mallard

So far Mallard just reads ``demo.ma`` at runtime, so it's not really useful as
an interpreter. You can mess with that file to see how mallard parses things.

Preview
-------

::

    print "demo program"
    let name = getline "What is your name?"
    match ->
        = name "billy" ->
            print "That's a nice name"
        true ->
            print "Get a better name"

About the Language
------------------

Mallard is functional. It uses polish notation for operators (which are really
just functions). It also allows mutable values, although they are strongly
discouraged unless absolutely necessary. The reserved names and keywords are
listed below:
::
    let atom data match true false nil = == != | || & && < > <= >= ->

These may not be used as variable or function names.

Writing in Mallard
~~~~~~~~~~~~~~~~~~

``let`` creates an immutable value. Use it to create constants. This should be
used most often, unless mutability is absolutely necessary.

``atom`` is used to create mutable values. The ``set`` function can be used to
set the value of an atom. Note that this is a thread-safe operation, you don't
have to manually lock the atom since all operations on atoms are atomic, hence
the name.

The rest of the stuff will be documented once the language actually works.

Standard Library
~~~~~~~~~~~~~~~~

My goal with this project is to implement the majority of the standard library
in Mallard itself. It is of course necessary to define some functions at in the
interpreter, such as IO operations, arithmetic, lambdas, and register
manipulation, but the rest, such as string formating, parsing for various file
types, and abstracted HTTP support will be hopefully implemented in Mallard.

Implementation
--------------
* Lexer works, it tokenizes all of the tokens currently included in the language
* Parser works partially, can parse some but not all of the tokens from the
    lexer into a tree. So far, the following are supported:
        * Identifiers
        * Let keyword
        * Numbers
        * Strings
        * Indented Lambdas
    More will be implemented eventually when I have more time.

License
-------
::

    The MIT License (MIT)

    Copyright (c) 2018 swissChili

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
