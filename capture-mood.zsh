#!/usr/bin/env zsh

# Stop on errors.
set -e

# cd to the directory of this script.
cd $0:A:h

# This number should be incremented every time the format of entries
# written to the log file changes.
local format_version=1

# String to be printed between sections of I/O.
local separator="----------------------------------------"

# Timestamp for notification was displayed (optional, provided as
# first argument by attempt-mood-capture.zsh via
# capture-mood.applescript).
local notification_timestamp=$1

# Timestamp for beginning of mood capture.
local capture_start_timestamp=$(date +%s)

# Display levels of mood.
echo "(1) Terrible"
echo "(2) Pretty bad"
echo "(3) A little slow"
echo "(4) Pretty reasonable"
echo "(5) Quite good"
echo "(6) Great"
echo "(7) Fantastic"
echo $separator

# Loop until a valid mood is provided.
while true; do
    # Read only one keypress.
    local mood
    read -k "mood?How are you feeling? "
    # Move to a new line after keypress is accepted.
    echo
    # The only valid moods are the single digits 1-7.
    if [[ $mood =~ ^[1-7]$ ]]; then
        break
    fi
done

# Optional comment.
echo $separator
local comment=
vared -e -p "Comment: " -c comment
# Escape colons and backslashes with an additional backslash.
comment=$(echo $comment | sed 's/[\\:]/\\&/')

# Timestamp for end of mood capture.
local capture_end_timestamp=$(date +%s)

# The log file is line-oriented, with the fields in each line
# delimited by colons. (Embedded colons and backslashes are
# backslash-escaped.) The first field is an integer identifying the
# version of the format this line adheres to. The second field is an
# integer, 1-7, identifying my mood. The third field is optional (i.e.
# can be empty) and is a comment identifying what I was doing at the
# time, or any other information I think is important to remember. The
# fourth field is the timestamp for when the notification was
# displayed on the screen; this is empty if capture-mood was called
# directly. The fifth field is the timestamp for when the mood entry
# was begun. The sixth field is the timestamp for when the entry was
# completed.
echo ":\
$format_version:\
$mood:\
$comment:\
$notification_timestamp:\
$capture_start_timestamp:\
$capture_end_timestamp:\
" >> moods.log
