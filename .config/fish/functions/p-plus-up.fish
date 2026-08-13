function p-plus-up --description "Open 3 new tabs in the current Ghostty window running the P+ portal + service dev stack"
    set -l portal_dir ~/git/p-plus/p-plus-portal
    set -l service_dir ~/git/p-plus/p-plus-service
    set -l state_file /tmp/p-plus-dev-tabs

    set -l result (osascript \
        -e 'tell application "Ghostty"' \
        -e 'set win to front window' \
        -e 'set originalTab to selected tab of win' \
        -e 'set cfg1 to new surface configuration' \
        -e "set initial working directory of cfg1 to \"$portal_dir\"" \
        -e 'set command of cfg1 to "npm run dev"' \
        -e 'set wait after command of cfg1 to true' \
        -e 'set tab1 to new tab in win with configuration cfg1' \
        -e 'set cfg2 to new surface configuration' \
        -e "set initial working directory of cfg2 to \"$portal_dir\"" \
        -e 'set command of cfg2 to "npx overmind-devtools@latest"' \
        -e 'set wait after command of cfg2 to true' \
        -e 'set tab2 to new tab in win with configuration cfg2' \
        -e 'set cfg3 to new surface configuration' \
        -e "set initial working directory of cfg3 to \"$service_dir\"" \
        -e 'set command of cfg3 to "npm run dev"' \
        -e 'set wait after command of cfg3 to true' \
        -e 'set tab3 to new tab in win with configuration cfg3' \
        -e 'select tab originalTab' \
        -e '(id of win) & "|" & (id of tab1) & "|" & (id of tab2) & "|" & (id of tab3)' \
        -e 'end tell')

    echo $result >$state_file

    set -l tries 0
    while test $tries -lt 30; and not nc -z localhost 4000 2>/dev/null
        sleep 0.5
        set tries (math $tries + 1)
    end

    set -l tries 0
    while test $tries -lt 30; and not nc -z localhost 8080 2>/dev/null
        sleep 0.5
        set tries (math $tries + 1)
    end

    # overmind-devtools launches its own Electron window (npx install + boot can take a while,
    # and it steals focus once it appears) — wait for it so it doesn't pop up after the browser
    set -l ot_tries 0
    while test $ot_tries -lt 60
        set -l has_electron (osascript -e 'tell application "System Events" to (name of processes) contains "Electron"' 2>/dev/null)
        if test "$has_electron" = true
            break
        end
        sleep 0.5
        set ot_tries (math $ot_tries + 1)
    end

    # small settle delay so async focus (Ghostty's tab-select, Electron's own activate) can't land after the browser opens
    sleep 1
    open http://localhost:4000
end
