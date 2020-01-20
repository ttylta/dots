import sys, os

# Fonts
font = "bold 11pt Misc Tamsyn"
c.fonts.completion.entry = font
c.fonts.completion.category = font
c.fonts.debug_console = font
c.fonts.downloads = font
c.fonts.hints = font
c.fonts.keyhint = font
c.fonts.messages.error = font
c.fonts.messages.info = font
c.fonts.messages.warning = font
c.fonts.prompts = font
c.fonts.statusbar = font
c.fonts.tabs = font

#tabs
c.tabs.favicons.show = "never"
c.tabs.padding = {"bottom": 15, "left": 12, "right": 12, "top": 0}

# Ad-blocking
sys.path.append(os.path.join(sys.path[0], "jblock"))
config.source("jblock/jblock/integrations/qutebrowser.py")
config.set(
    "content.host_blocking.lists",
    [
        "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
        "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt",
        "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt",
        "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt",
        "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt",
        "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt",
    ])

# MPV youtube hints
config.bind('M', 'hint links spawn --detach mpv --force-window yes {hint-url}')

# Pywal theme
config.source('qutewal.py')
