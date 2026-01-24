**Overview**
- Personal Hammerspoon setup for window management and app launching.
- Window layouts support gaps, portrait/landscape screens, and multi-screen workflows.
- App launcher provides Spotlight-like launch/focus shortcuts.

**Structure**
- `init.lua` loads `config/keymaps.lua`.
- `config/options.lua` holds global settings like `gap` and app names.
- `config/keymaps.lua` defines all hotkeys.
- `modules/window-manager` implements grid positioning, screen logic, and window actions.
- `modules/app-launcher` implements app launch/focus behavior.
- `modules/window-utils.lua` holds shared screen/space helpers.

**Window Shortcuts**
- `opt+h` left half
- `opt+l` right half
- `opt+j` center half
- `opt+k` almost maximize (gap on all edges)
- `ctrl+opt+h` left third
- `ctrl+opt+l` right third
- `ctrl+opt+g` left two thirds
- `ctrl+opt+;` right two thirds
- `ctrl+opt+j` center third
- `ctrl+opt+k` center two thirds
- `opt+a` arrange visible windows on active screen
- `opt+r` rotate window positions on active screen
- `opt+x` cycle focus on active screen
- `opt+z` cycle focus to next screen
- `opt+p` append focused window to next screen and arrange
- `ctrl+opt+p` append focused window to next screen without rearranging

**App Shortcuts**
- `opt+t` terminal
- `opt+n` notes
- `opt+e` text editor
- `opt+f` Finder
- `opt+b` browser (new window in active space if none exists)
- `opt+u` music player
- `opt+m` mail (placeholder)
- `opt+c` calendar (placeholder)
- `opt+s` Slack (placeholder)
- `opt+d` Discord (placeholder)
- `opt+g` Telegram (placeholder)
- `opt+w` WhatsApp (placeholder)
- `opt+i` AI app (placeholder)

**Notes**
- Portrait displays swap row/column logic so layouts feel top-to-bottom.
- Adjust app names and gap in `config/options.lua`, then reload Hammerspoon.
