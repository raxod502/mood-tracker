tell application "iTerm"
    -- The path might have spaces in it. But we shouldn't need to
    -- worry too much about the timestamp, since it's just an integer.
    create window with default profile command "\"<PWD>/capture-mood.zsh\" <TIMESTAMP>"
    activate
end tell
