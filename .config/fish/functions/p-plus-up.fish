function p-plus-up --description "Open 3 new tabs in the current Ghostty window running the P+ portal + service dev stack"
    set -l portal_dir ~/git/p-plus/p-plus-portal
    set -l service_dir ~/git/p-plus/p-plus-service

    osascript \
        -e 'tell application "Ghostty"' \
        -e 'set win to front window' \
        -e 'set originalTab to selected tab of win' \
        -e 'set cfg1 to new surface configuration' \
        -e "set initial working directory of cfg1 to \"$portal_dir\"" \
        -e 'set command of cfg1 to "npm run dev"' \
        -e 'set wait after command of cfg1 to true' \
        -e 'new tab in win with configuration cfg1' \
        -e 'set cfg2 to new surface configuration' \
        -e "set initial working directory of cfg2 to \"$portal_dir\"" \
        -e 'set command of cfg2 to "npx overmind-devtools@latest"' \
        -e 'set wait after command of cfg2 to true' \
        -e 'new tab in win with configuration cfg2' \
        -e 'set cfg3 to new surface configuration' \
        -e "set initial working directory of cfg3 to \"$service_dir\"" \
        -e 'set command of cfg3 to "npm run dev"' \
        -e 'set wait after command of cfg3 to true' \
        -e 'new tab in win with configuration cfg3' \
        -e 'select tab originalTab' \
        -e 'end tell'
end
