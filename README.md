sertify | S[tring] [C]ertify
----------------------------

Generate input validation code in many languages based on YAML templates.

We all write input validation functions. All the time. In all kinds of
different languages. Every one of our implementations varies, making it hard
for data passed between multiple applications written in different
languages to validate in the same way. One validation test might pass in
one program, but then when it is passed on to the next, it fails, creating
a gauntlet of input validation functions that is very unpredictable.
Ideally, you keep the input validation in the same place. But when you
support multiple input methods (command line, via a REST interface, from
a shared library, etc..), there comes a need to validate the same data
in the same way, in different applications.

This software is a weekend experiment. It might be useful, but defnitely
needs more TLC.

In its most simple form, you can take an input file that looks something
like this...

```
name: fqdn
min_len: 5
max_len: 256
regex: ^[a-z0-9]([a-z0-9-]+)?((\.[a-z0-9-]+)+)?\.[a-z]+$
```

... and render it in multiple different programming languages!

Example generating bash code:

```
irb(main):003:0> print Sertify::Bash.render('checks/fqdn')
function is_fqdn() {
    [[ "$1" =~ ^[a-z0-9]([a-z0-9-]+)?((\.[a-z0-9-]+)+)?\.[a-z]+$ ]] || return 1
    [ ${#1} -ge 5 ] || return 1
    [ ${#1} -le 256 ] || return 1
    return 0
}
=> nil
```

Generating Python code using the same input file as above:

```
irb(main):003:0> print Sertify::Python.render('checks/fqdn')
def is_fqdn(input):
    from re import match
    if not match('^[a-z0-9]([a-z0-9-]+)?((\.[a-z0-9-]+)+)?\.[a-z]+$', input):
        return False
    if len(input) < 5:
        return False
    if len(input) > 256:
        return False
    return True
=> nil
```

Currently supported language renderers
--------------------------------------

* Bash
* Ruby
* Python
* PHP

Syntax of input file
--------------------

Input files are simple YAML documents describing what to check.
Here are the various options you can use to write your function metadata:

`name`
This is the name of the check. The function name will be `is_{name}`.

`min`
Compare the input text as an integer, and make sure it has an absolute value
at least equivalent to this argument.

`max`
Similar to min, but specifies the maximum integer allowed.

`min_len`
Ensure that a string is at least of this length

`max_len`
Ensure that the string length is at most equivalent to this argument.

`regex`
This can be either a single regular expression or a list of them. If a list
is specified, all regular expressions in the list MUST pass in order for
the function to return success.

`one_of`
This is a list of regular expressions, of which at least one (but potentially
more than one) needs to match in order to continue.

`chunks`
The chunks object allows you to split the input string into multiple smaller
strings to execute tests on smaller pieces of text. This solves a lot of
problems where a regular expression is either not possible or far too
complicated to evaluate chunks of text.

`split_by`
Within the chunks object, you can use this tag to specify the delimiter
string for the input.
