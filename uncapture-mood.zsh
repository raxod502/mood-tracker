#!/usr/bin/env zsh

set -e
cd $0:A:h

if [[ -s moods.log ]]; then
    tail -n 1 moods.log
    read -q "response?Delete? [y/N] "
    if [[ $response == y ]]; then
        sed -i .bak '$d' moods.log
        rm -f moods.log.bak
    else
        exit 1
    fi
    echo
else
    echo "No moods saved!"
    exit 1
fi
