function p-plus-down --description "Stop the P+ dev stack (portal, overmind-devtools, service) and close their Ghostty tabs"
    set -l state_file /tmp/p-plus-dev-tabs

    if not test -f $state_file
        echo "No p-plus dev tabs found — did you run p-plus-up?"
        return 1
    end

    set -l parts (string split "|" (cat $state_file))
    if test (count $parts) -ne 4
        echo "p-plus dev tab state looks corrupted, removing it"
        rm -f $state_file
        return 1
    end

    set -l win_id $parts[1]
    set -l tab1_id $parts[2]
    set -l tab2_id $parts[3]
    set -l tab3_id $parts[4]

    osascript \
        -e 'tell application "Ghostty"' \
        -e "set targetWindows to (every window whose id is \"$win_id\")" \
        -e 'if (count of targetWindows) = 0 then' \
        -e 'return' \
        -e 'end if' \
        -e 'set win to item 1 of targetWindows' \
        -e "set tabIds to {\"$tab1_id\", \"$tab2_id\", \"$tab3_id\"}" \
        -e 'repeat with tid in tabIds' \
        -e 'try' \
        -e 'set t to (tab id tid of win)' \
        -e 'try' \
        -e 'send key "c" modifiers "control" to (focused terminal of t)' \
        -e 'end try' \
        -e 'end try' \
        -e 'end repeat' \
        -e 'delay 1.5' \
        -e 'repeat with tid in tabIds' \
        -e 'try' \
        -e 'set t to (tab id tid of win)' \
        -e 'close tab t' \
        -e 'end try' \
        -e 'end repeat' \
        -e 'end tell'

    rm -f $state_file
    echo "Stopped p-plus dev stack and closed its tabs"
end
