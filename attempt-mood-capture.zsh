#!/usr/bin/env zsh

set -e
cd $0:A:h

if ! (( $+commands[terminal-notifier] )); then
    cat display-error-notification.applescript |
        sed 's/<DEPENDENCY>/terminal-notifier/' |
        osascript
elif ! [[ -e /Applications/iTerm.app ]]; then
    cat display-error-notification.applescript |
        sed 's/<DEPENDENCY>/iTerm2/' |
        osascript
else
    local result=$(terminal-notifier -message "Capture your mood?" -actions Capture)
    if [[ $result == @CONTENTCLICKED || $result == Capture ]]; then
        local escaped_pwd=$(
            echo $PWD |
                sed 's/"/\"/' | # escape for zsh double quotes
                sed 's/"/\"/' | # escape for AppleScript double quotes
                sed 's/[\/&]/\\&/g') # escape for sed
        cat capture-mood.applescript |
            sed "s/<PWD>/$escaped_pwd/" |
            osascript
    fi
fi
