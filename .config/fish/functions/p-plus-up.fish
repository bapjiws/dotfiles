function p-plus-up --description "Open a Ghostty window with the P+ portal + service dev stack running in separate tabs"
    set -l portal_dir ~/git/p-plus/p-plus-portal
    set -l service_dir ~/git/p-plus/p-plus-service

    osascript \
        -e 'tell application "Ghostty"' \
        -e 'activate' \
        -e 'set cfg1 to new surface configuration' \
        -e "set initial working directory of cfg1 to \"$portal_dir\"" \
        -e 'set command of cfg1 to "npm run dev"' \
        -e 'set wait after command of cfg1 to true' \
        -e 'set win to new window with configuration cfg1' \
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
        -e 'end tell'
end
