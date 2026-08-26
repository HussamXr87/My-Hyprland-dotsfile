
------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1,
})


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--

hl.on("hyprland.start", function ()
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("waybar")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("swaync")
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("awww-daemon")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Lock and Feel
require("hyprland.decoration")

-- Animations
require("hyprland.animations")

-- Input 
require("hyprland.input")

-- Keybinding 
require("hyprland.keybindings")

-- Windows_rules 
require("hyprland.windows_rules")