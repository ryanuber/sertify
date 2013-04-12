sertify - Certify string data
-----------------------------

Generate input validation code in many languages based on YAML templates.

In its most simple form, you can take an input file that looks something
like this...

```
name: fqdn
min_len: 5
max_len: 256
regex: ^[a-z0-9]([a-z0-9-]+)?((\.[a-z0-9-]+)+)?\.[a-z]+$
```

... and render it in multiple different programming languages!

bash

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

Ruby

```
irb(main):004:0> print Sertify::Ruby.render('checks/fqdn')
def is_fqdn(input)
  return false if not /^[a-z0-9]([a-z0-9-]+)?((\.[a-z0-9-]+)+)?\.[a-z]+$/.match(input)
  return false if input.length < 5
  return false if input.length > 256
  return true
end
=> nil
```

Python

```
irb(main):005:0> print Sertify::Python.render('checks/fqdn')
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

PHP

```
irb(main):006:0> print Sertify::Php.render('checks/fqdn')
function is_fqdn($input) {
    if (preg_match('/^[a-z0-9]([a-z0-9-]+)?((\.[a-z0-9-]+)+)?\.[a-z]+$/', $input) != 1) {
        return false;
    }
    if (strlen($input) < 5) {
        return false;
    }
    if (strlen($input) > 256) {
        return false;
    }
    return true;
}
=> nil
```
