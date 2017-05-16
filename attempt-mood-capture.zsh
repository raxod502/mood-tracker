#!/usr/bin/env zsh

set -e
cd $0:A:h

# Homebrew installation directory is not added to PATH by cron.
path+=(/usr/local/bin)

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
    result=$(terminal-notifier \
                 -message "Capture your mood?" \
                 -actions Capture \
                 -timeout 1800 2>&1)
    # Proceed if the user clicked on the notification box or the
    # Capture button.
    if [[ $result == *@CONTENTCLICKED || $result == *@Capture ]]; then
        escaped_pwd=$(
            echo $PWD |
                sed 's/"/\"/' | # escape for zsh double quotes
                sed 's/"/\"/' | # escape for AppleScript double quotes
                sed 's/[\/&]/\\&/g') # escape for sed
        cat capture-mood.applescript |
            sed "s/<PWD>/$escaped_pwd/" |
            sed "s/<TIMESTAMP>/$(date +%s)/" |
            osascript > /dev/null
    fi
fi
