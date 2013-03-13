#!/bin/bash
function vet_ip4()
{
    [[ "$1" =~ ^([1-9][0-9]{0,2}\.){3}[1-9][0-9]{0,2}$ ]] || return 1
    for OCT in ${1//\./ }; do
        [ $OCT -lt 256 ] || return 1
    done
    return 0
}

function vet_ip6()
{
    return 1
}


