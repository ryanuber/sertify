sertify | S[tring] [C]ertify
----------------------------

Generate input validation code in many languages based on YAML templates.

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
