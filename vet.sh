#!/bin/bash
function vet_ip4()
{
    [[ "$1" =~ ^[1-9]([0-9]){0,2}(\.[0-9]{1,3}){3}$ ]] || return 1
    for OCT in ${1//\./ }; do
        [ ${#OCT} -gt 1 ] && [ ${OCT:0:1} -eq 0 ] && return 1
        [ $OCT -lt 256 ] || return 1
    done
    return 0
}

function vet_fqdn()
{
    [[ "$1" =~ ^[a-z0-9]([a-z0-9-]+)?((\.[a-z0-9-]+)+)?\.[a-z]+$ ]] || return 1
    [ ${#1} -lt 257 ] || return 1
    return 0
}
