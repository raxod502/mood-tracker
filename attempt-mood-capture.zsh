#!/usr/bin/env zsh

set -e
cd $0:A:h

if ! (( $+commands[terminal-notifier] )); then
    # Required dependency: brew install terminal-notifier
    cat display-error-notification.applescript |
        sed 's/<DEPENDENCY>/terminal-notifier/' |
        osascript
elif ! [[ -e /Applications/iTerm.app ]]; then
    # Required dependency: brew cask install iterm2
    cat display-error-notification.applescript |
        sed 's/<DEPENDENCY>/iTerm2/' |
        osascript
else
    # Show a notification.
    local result=$(terminal-notifier -message "Capture your mood?" -actions Capture)
    # Proceed if the user clicked on the notification box or the
    # Capture button.
    if [[ $result == @CONTENTCLICKED || $result == Capture ]]; then
        local escaped_pwd=$(
            echo $PWD |
                sed 's/"/\"/' | # escape for zsh double quotes
                sed 's/"/\"/' | # escape for AppleScript double quotes
                sed 's/[\/&]/\\&/g') # escape for sed
        cat capture-mood.applescript |
            sed "s/<PWD>/$escaped_pwd/" |
            sed "s/<TIMESTAMP>/$(date +%s)/" |
            osascript
    fi
fi
