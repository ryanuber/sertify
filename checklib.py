from re import match

def is_ip4(address):
    if match('^[1-9]([0-9]){0,2}(\.[0-9]{1,3}){3}$', address) == None:
        return False
    for oct in address.split('.'):
        if (len(oct) > 1 and int(oct[0]) == 0) or int(oct) >= 256:
            return False
    return True

def is_fqdn(hostname):
    if match('^[a-z0-9]([a-z0-9-]+)?((\.[a-z0-9-]+)+)?\.[a-z]+$', hostname) == None:
        return False
    if len(hostname) >= 257:
        return False
    return True
