#!/usr/bin/env zsh

set -e
cd $0:A:h

local format_version=1
local separator="----------------------------------------"

local mood=
while true; do
    echo "(1) Terrible"
    echo "(2) Pretty bad"
    echo "(3) A little slow"
    echo "(4) Pretty reasonable"
    echo "(5) Quite good"
    echo "(6) Great"
    echo "(7) Fantastic"
    vared -e -p "How are you feeling? " -c mood
    if [[ $mood =~ ^[1-7]$ ]]; then
        break
    fi
    echo $separator
done

echo $separator
local comment=
vared -e -p "Comment: " -c comment
comment=$(echo $comment | sed 's/:/\:/')

echo ":$format_version:$mood:$comment:" >> moods.log
