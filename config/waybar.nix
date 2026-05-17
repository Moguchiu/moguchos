{
  pkgs,
  lib,
  host,
  config,
  ...
}:

let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  inherit (import ../hosts/${host}/variables.nix) clock24h;
in
with lib;
{
  # Configure & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = concatStrings [
    ''
    {
    //"layer": "top", // Waybar at top layer
     "position": "bottom", // Waybar position (top|bottom|left|right)
    //"height": 20, // Waybar height (to be removed for auto height)
    //"width": 1280, // Waybar width
    "spacing": 4, // Gaps between modules (4px)
    // Choose the order of the modules
		"reload_style_on_change": true,
    "modules-left": ["clock", "hyprland/workspaces", "sway/scratchpad"],
    "modules-center": ["custom/media"],
    "modules-right": ["pulseaudio", "memory", "cpu", "temperature","tray", "group/group-power"],
	"group/group-power": {
	    "orientation": "horizontal",
	    "drawer": {
		"transition-duration": 500,
		"children-class": "not-power",
		"transition-left-to-right": false,
	    },
	    "modules": [
		"custom/power", 
		"custom/quit",
		"custom/lock",
		"custom/reboot",
	    ]
	},
	"custom/quit": {
	    "format": " 󰗼 ",
	    "tooltip": false,
	    "on-click": "swaymsg exit"
	},
	"custom/lock": {
	    "format": " 󰍁 ",
	    "tooltip": false,
	    "on-click": "swaylock --screenshots --clock --indicator --effect-blur 12x7"
	},
	"custom/reboot": {
	    "format": " 󰜉 ",
	    "tooltip": false,
	    "on-click": "reboot"
	},
	"custom/power": {
	    "format": "  ",
	    "tooltip": false,
	    "on-click": "shutdown now"
	},
	"group/hardware": {
		"orientation": "horizontal",
		"drawer": {
			"transition-duration": 500,
			"children-class": "not-memory",
			"transition-left-to-right": false,
		},
		"modules": [
			"memory",
			"cpu",
			"temperature",
		]
	},
    "keyboard-state": {
        "numlock": true,
        "capslock": true,
        "format": "{name} {icon}",
        "format-icons": {
            "locked": "",
            "unlocked": ""
        }
    },
    "sway/mode": {
        "format": "<span style=\"italic\">{}</span>"
    },
    "sway/scratchpad": {
        "format": "{icon} {count}",
        "show-empty": false,
        "format-icons": ["", ""],
        "tooltip": true,
        "tooltip-format": "{app}: {title}"
    },
    "mpd": {
//        "format": "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ",
        "format": "  {title} - {artist} {stateIcon} [{elapsedTime:%M:%S}/{totalTime:%M:%S}] {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}[{songPosition}/{queueLength}] [{volume}%]",
        "format-disconnected": " Disconnected",
        "format-stopped": " {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped",
        "unknown-tag": "N/A",
        "interval": 2,
        "consume-icons": {
            "on": " "
        },
        "random-icons": {
//            "off": "<span color=\"#f53c3c\"></span> ",
            "on": " "
        },
        "repeat-icons": {
            "on": " "
        },
        "single-icons": {
            "on": "1 "
        },
        "state-icons": {
            "paused": "",
            "playing": ""
        },
        "tooltip-format": "MPD (connected)",
        "tooltip-format-disconnected": "MPD (disconnected)",
        "on-click": "mpc toggle",
        "on-click-right": "foot -a ncmpcpp ncmpcpp",
        "on-scroll-up": "mpc volume +2",
        "on-scroll-down": "mpc volume -2"

    },
    "idle_inhibitor": {
        "format": "{icon}",
        "format-icons": {
            "activated": " ",
            "deactivated": " "
        }
    },
    "tray": {
        // "icon-size": 21,
        "spacing": 10
    },
    "clock": {
        // "timezone": "America/New_York",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        //"format-alt": "{:%Y-%m-%d}"
        "format": "<big>{:%H:%M}</big>  "
        //"format": "{:%Y-%m-%d %H:%M}"
    },
    "cpu": {
        "format": "CPU {usage}%",
//        "tooltip": false
    },
    "memory": {
        "format": "MEM {}%"
    },
    "temperature": {
        "thermal-zone": 2,
        "hwmon-path": "/sys/class/hwmon/hwmon1/temp1_input",
        "critical-threshold": 80,
        "format-critical": "TEMP: {temperatureC}°C",
        "format": "TEMP {temperatureC}°C",
        "format-icons": ["", "", ""]
    },
    "backlight": {
        // "device": "acpi_video1",
        "format": "{icon} {percent}%",
        "format-icons": ["", "", "", "", "", "", "", "", ""]
    },
    "battery": {
        "states": {
            // "good": 95,
            "warning": 30,
            "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": " {capacity}%",
        "format-plugged": " {capacity}%",
        "format-alt": "{icon} {time}",
        // "format-good": "", // An empty format will hide the module
        // "format-full": "",
        "format-icons": ["", "", "", "", ""]
    },
    "battery#bat2": {
        "bat": "BAT2"
    },
    "network": {
        // "interface": "wlp2*", // (Optional) To force the use of this interface
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": " {ifname}",
        "tooltip-format": " {ifname} via {gwaddr}",
        "format-linked": " {ifname} (No IP)",
        "format-disconnected": "Disconnected ⚠ {ifname}",
        "format-alt": " {ifname}: {ipaddr}/{cidr}"
    },
    "pulseaudio": {
        "scroll-step": 5, // %, can be a float
        "format": "{icon} {format_source}",
        "format-bluetooth": " {icon} {volume}% {format_source}",
        "format-bluetooth-muted": "  {icon} {format_source}",
        "format-muted": "󰝟 {format_source}",
        "format-source": "",
        "format-source-muted": "",
        "format-icons": {
//            "headphone": " ",
//            "hands-free": " ",
//            "headset": "",
//            "phone": "",
//            "portable": "",
//            "car": "",
            "default": ["", " ", " "]
        },
        "on-click": "pavucontrol",
        "on-click-right": "foot -a pw-top pw-top"
    },
    "hyprland/window": {
	    "format": "👉 {}",
	    "rewrite": {
		"(.*) — Mozilla Firefox": "🌎 $1",
		"(.*) - fish": "> [$1]"
	    },
	    "separate-outputs": true
    },
    "hyprland/workspaces": {
	    "format": "{icon}",
	    "format-icons": {
		"1": " ",
		"2": "󰖟 ",
		"3": " ",
		"4": "󰓓 ",
		"5": "󰭹 ",
		"6": " ",
		"10": "󱌢 ",
		"urgent": "!",
		"default": " ",
	    }
    },
    "custom/media": {
	    "format": "󰄾 {0} {1} 󰄽",
	    "escape": true,
	    "return-type": "json",
	    "max-length": 40,
	    "on-click": "playerctl play-pause",
	    "on-click-right": "playerctl stop",
	    "smooth-scrolling-threshold": 10, 
	    "on-scroll-up": "playerctl next",
	    "on-scroll-down": "playerctl previous",
	    "exec": "python $HOME/.config/waybar/mediaplayer.py 2> /dev/null", 
	},
	"custom/left": {
		"format": "<span size='20pt'></span>",
	},
	"custom/right": {
		"format": "<span size='20pt'></span>",
	},
	"custom/secondleft": {
		"format": "<span size='20pt'></span>",
	},
	"custom/secondright": {
		"format": "<span size='20pt'></span>",
	},
	"custom/thirdleft": {
		"format": "<span size='20pt'></span>",
	},
	"custom/thirdright": {
		"format": "<span size='20pt'></span>",
	},
},
    ''
    ];
    style = concatStrings [
      ''
      * {
  font-family: "Terminess Nerd Font";
  font-size: 18px;
  min-height: 0;
}

/* Retro green color palette inspired by your desktop:
 * Dark Green Base: #1a3a2e (background)
 * Medium Green: #2d5f4d (secondary background)
 * Sage Green: #7fb894 (primary accents)
 * Bright Green: #9fd4af (highlights)
 * Deep Forest: #0f2419 (darkest)
 * Lime Accent: #b8e6c9 (brightest)
 * Peachy Coral: #e89d8a (alerts only)
 */

window#waybar {
  background: #1a3a2e;
  border-top: 3px solid #7fb894;
  border-bottom: 1px solid #2d5f4d;
  color: #b8e6c9;
  transition-property: background-color;
  transition-duration: .5s;
  box-shadow: inset 0 2px 0 rgba(127, 184, 148, 0.3);
}

window#waybar.hidden {
  opacity: 0.2;
}

#waybar.empty #window {
  background-color: transparent;
}

#window {
  background-color: transparent;
}

.modules-left {
  margin-top: 0.5em;
  margin-left: 0.5em;
  background: #2d5f4d;
  color: #b8e6c9;
  border-radius: 0px;
  padding: 4px 8px;
  border: 2px solid #7fb894;
  border-left: 4px solid #7fb894;
  box-shadow: 3px 3px 0 rgba(0, 0, 0, 0.4);
}

.modules-right {
  margin-top: 0.5em;
  margin-right: 0.5em;
  background: #2d5f4d;
  color: #b8e6c9;
  border-radius: 0px;
  padding: 4px 8px;
  border: 2px solid #7fb894;
  border-right: 4px solid #7fb894;
  box-shadow: -3px 3px 0 rgba(0, 0, 0, 0.4);
} 

.modules-center {
  margin-top: 0.5em;
  background: #2d5f4d;
  color: #9fd4af;
  border-radius: 0px;
  padding: 4px 12px;
  border: 2px solid #7fb894;
  box-shadow: 0 3px 0 rgba(0, 0, 0, 0.4);
}

#workspaces {
  color: #b8e6c9;
  padding-right: 0px;
  margin-left: 8px;
}

#custom-logout,
#window {
  margin: 2;
  padding-left: 8;
  padding-right: 8;
  font-size: 14px;
  font-weight: bold;
}

button {
  box-shadow: none;
  border: none;
  border-radius: 0px;
}

button:hover {
  background: #2d5f4d;
  color: #9fd4af;
  transition: all 0.1s ease;
  border-left: 2px solid #9fd4af;
}

#workspaces button {
  padding: 0 10px;
  margin: 0 1px;
  color: #7fb894;
  background: #0f2419;
  border-radius: 0px;
  border: 2px solid #1a3a2e;
  border-top: 0;
  border-bottom: 0;
  transition: all 0.1s ease;
}

#workspaces button:hover {
  color: #b8e6c9;
  background: #2d5f4d;
  border: 2px solid transparent;
  animation: border-chase 1s linear infinite;
}

#workspaces button.active {
  padding: 0 12px;
  background: #7fb894;
  color: #0f2419;
  font-weight: bold;
  border: 3px solid #9fd4af;
  border-top: 3px solid #b8e6c9;
  border-bottom: 3px solid #1a3a2e;
  box-shadow: inset 0 2px 0 rgba(184, 230, 201, 0.4), inset 0 -2px 0 rgba(0, 0, 0, 0.3);
}

#workspaces button.urgent {
  color: #0f2419;
  background: #e89d8a;
  border: 3px solid #ffffff;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  from { 
    opacity: 1; 
  }
  50% { 
    opacity: 0.6; 
  }
  to { 
    opacity: 1; 
  }
}

@keyframes border-chase {
  0% {
    border-top-color: #b8e6c9;
    border-right-color: rgba(184, 230, 201, 0.3);
    border-bottom-color: rgba(184, 230, 201, 0.1);
    border-left-color: rgba(184, 230, 201, 0.5);
  }
  25% {
    border-top-color: rgba(184, 230, 201, 0.5);
    border-right-color: #b8e6c9;
    border-bottom-color: rgba(184, 230, 201, 0.3);
    border-left-color: rgba(184, 230, 201, 0.1);
  }
  50% {
    border-top-color: rgba(184, 230, 201, 0.1);
    border-right-color: rgba(184, 230, 201, 0.5);
    border-bottom-color: #b8e6c9;
    border-left-color: rgba(184, 230, 201, 0.3);
  }
  75% {
    border-top-color: rgba(184, 230, 201, 0.3);
    border-right-color: rgba(184, 230, 201, 0.1);
    border-bottom-color: rgba(184, 230, 201, 0.5);
    border-left-color: #b8e6c9;
  }
  100% {
    border-top-color: #b8e6c9;
    border-right-color: rgba(184, 230, 201, 0.3);
    border-bottom-color: rgba(184, 230, 201, 0.1);
    border-left-color: rgba(184, 230, 201, 0.5);
  }
}

#mode {
  background-color: #2d5f4d;
  border: 3px solid #7fb894;
  border-bottom: 4px solid #7fb894;
  color: #b8e6c9;
}

#clock {
  color: #0f2419;
  background: #7fb894;
  padding: 4px 12px;
  border-radius: 0px;
  font-weight: bold;
  margin-right: 8px;
  border: 3px solid #9fd4af;
  border-top: 3px solid #b8e6c9;
  border-bottom: 3px solid #1a3a2e;
  box-shadow: inset 0 2px 0 rgba(184, 230, 201, 0.4), inset 0 -2px 0 rgba(0, 0, 0, 0.3), 2px 2px 0 rgba(0, 0, 0, 0.3);
}

#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#wireplumber,
#tray,
#mode,
#idle_inhibitor,
#scratchpad {
  margin: 2px 3px;
  padding: 4px 10px;
  color: #b8e6c9;
  background: #2d5f4d;
  border-radius: 0px;
  border: 2px solid #1a3a2e;
  transition: all 0.1s ease;
}

#battery:hover,
#cpu:hover,
#memory:hover,
#temperature:hover,
#pulseaudio:hover {
  background: #3d6f5d;
  border: 2px solid #7fb894;
  box-shadow: 2px 2px 0 rgba(0, 0, 0, 0.3);
}

#custom-media,
#mpd {
  margin: 2px;
  padding: 4px 12px;
  color: #9fd4af;
  font-style: italic;
}

/* If workspaces is the leftmost module, omit left margin */
.modules-left > widget:first-child > #workspaces {
  margin-left: 0;
}

/* If workspaces is the rightmost module, omit right margin */
.modules-right > widget:last-child > #workspaces {
  margin-right: 0;
}

#battery.charging, #battery.plugged {
  color: #0f2419;
  background: #7fb894;
  border: 2px solid #9fd4af;
  font-weight: bold;
}

@keyframes blink {
  to {
    background-color: #e89d8a;
    color: #0f2419;
    border-color: #ffffff;
  }
}

#battery.warning:not(.charging) {
  background-color: #e89d8a;
  color: #0f2419;
  border: 2px solid #ffffff;
  animation-name: blink;
  animation-duration: 0.5s;
  animation-timing-function: steps(1);
  animation-iteration-count: infinite;
  animation-direction: alternate;
}

#battery.critical:not(.charging) {
  background-color: #e89d8a;
  color: #0f2419;
  border: 3px solid #ffffff;
  font-weight: bold;
  animation-name: blink;
  animation-duration: 0.5s;
  animation-timing-function: steps(1);
  animation-iteration-count: infinite;
  animation-direction: alternate;
}

label:focus {
  background-color: #2d5f4d;
}

#network.disconnected {
  color: #e89d8a;
  background: #2d5f4d;
  border: 2px solid #e89d8a;
}

#temperature.critical {
  background-color: #e89d8a;
  color: #0f2419;
  border: 2px solid #ffffff;
  font-weight: bold;
}

#idle_inhibitor.activated {
  background-color: #7fb894;
  color: #0f2419;
  border: 2px solid #9fd4af;
}

#tray > .passive {
  -gtk-icon-effect: dim;
}

#tray > .needs-attention {
  -gtk-icon-effect: highlight;
  background-color: #e89d8a;
  border: 2px solid #ffffff;
}

#group-power {
  background: #2d5f4d;
  color: #b8e6c9;
  font-size: 20px;
  border-radius: 0px;
  padding: 2px 4px;
  border: 2px solid #1a3a2e;
  box-shadow: 2px 2px 0 rgba(0, 0, 0, 0.3);
}

#group-power .not-power {
  background: #1a3a2e;
  margin: 0 2px;
  padding: 2px 8px;
  border-radius: 0px;
  border: 2px solid #2d5f4d;
  transition: all 0.1s ease;
}

#group-power .not-power:hover {
  background: #3d6f5d;
  color: #9fd4af;
  border: 2px solid #7fb894;
  box-shadow: 1px 1px 0 rgba(0, 0, 0, 0.5);
}

#custom-power {
  color: #e89d8a;
  font-weight: bold;
}

#custom-quit {
  color: #e89d8a;
}

#custom-lock {
  color: #9fd4af;
}

#custom-reboot {
  color: #b8e6c9;
}

#group-hardware {
  color: #b8e6c9;
  background: #2d5f4d;
  border-radius: 0px;
  border: 2px solid #1a3a2e;
}

#custom-left,
#custom-right,
#custom-secondleft, 
#custom-secondright,
#custom-thirdleft,
#custom-thirdright {
  color: #2d5f4d;
  background-color: transparent;
  padding: 0px;
  margin: 0px;
}

/* Tooltip styling */
tooltip {
  background: #2d5f4d;
  border: 2px solid #7fb894;
  border-radius: 0px;
  color: #b8e6c9;
  box-shadow: 3px 3px 0 rgba(0, 0, 0, 0.5);
}

tooltip label {
  color: #b8e6c9;
}
      ''
    ];
  };
}
