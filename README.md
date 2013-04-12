checklib
--------

Generate input validation code in many languages based on YAML templates.

Example IRB session generating bash, ruby, and python code, all from the same template:

```
$ irb
>> require 'CheckLib'
=> true
>> print CheckLib::Bash.render('checks/ip4.yml')
function is_ip4() {
    [ ${#1} -ge 7 ] || return 1
    [ ${#1} -le 17 ] || return 1
    for chunk in ${1//./ }; do
        [[ "$CHUNK" =~ ^[1-9][0-9]{0,2}$ ]] || return 1
        [ $CHUNK -ge 0 ] || return 1
        [ $CHUNK -le 255 ] || return 1
    done
    return 0
}
=> nil
>> print CheckLib::Ruby.render('checks/ip4.yml')
def is_ip4(input)
  return false if input.length < 7
  return false if input.length > 17
  input.split('.').each do |chunk|
    return false if not /^[1-9][0-9]{0,2}$/.match(chunk)
    return false if chunk.to_i < 0
    return false if chunk.to_i > 255
  end
  return true
end
=> nil
>> print CheckLib::Python.render('checks/ip4.yml')
def is_ip4(input):
    from re import match
    if len(input) < 7:
        return False
    if len(input) > 17:
        return False
    for chunk in input.split("."):
        if not match('^[1-9][0-9]{0,2}$', chunk):
            return False
        if int(chunk) < 0:
            return False
        if int(chunk) > 255:
            return False
    return True
```
