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
    settings = [
      {
        layer = "top";
        position = "top";
        modules-center = [
         "hyprland/workspaces"
         
        ];
        modules-left = [
          #"custom/startmenu"
          "clock"
          "custom/exit"
          "cava"
          "pulseaudio" 
          "backlight"
          "tray"
          #"idle_inhibitor"
        ];
        modules-right = [
          "custom/hyprbindings"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "network"
          "custom/notification"
          "hyprland/language"
          
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
          "1" = "∇"; 
          "2" = "∂"; 
          "3" = "∮";  
          "4" = "∑";  
          "5" = "∝"; 
          "6" = "∫";  
          "7" = "⧉";  
          "8" = "∬";  
          "9" = "∪";  
          "10" = "∀"; 
        };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        "clock" = {
          format = if clock24h == true then '' {:L%H:%M}'' else '' {:L%I:%M %p}'';
          tooltip = true;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          format-alt= "  {:%d/%m/%y}";          
        };
        #"hyprland/window" = {
        #  max-length = 22;
        #  separate-outputs = false;
        #  rewrite = {
        #    "" = " No Windows? ";
        #  };
        #};
        "backlight" = {
          format-icons = ["🌑" "🌒" "🌓" "🌔" "🌕"];
          format = "{icon} {percent}%";
          on-scroll-up = "brightnessctl set 5%+";
          on-scroll-down = "brightnessctl set 5%-";
         };
        "memory" = {
          interval = 5;
          format = " {}%";
          tooltip = true;
        };
        "cpu" = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
        };
        "temperature" = {
         interval = 2;
         tooltip = true;
         thermal-zone = 2;
         hwmon-path = ["/sys/class/hwmon/hwmon2/temp1_input" "/sys/class/thermal/thermal_zone0/temp" ];
         critical-threshold = 82;
         format-critical = "{icon} {temperatureC}°C";
         format = "{icon} {temperatureC}°C";
         format-icons = [""];
         on-click-right = "kitty --override font_size=14 --title btop sh -c 'btop'";
        };
        "hyprland/language" = {
         format = "{}";
         format-en = "US";
         format-ru = "RU";
        };        
        "network" = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = " {bandwidthDownOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
          on-click-right = "kitty --override font_size=14 --title nmtui sh -c 'nmtui'";
        };
        "tray" = {
          spacing = 12;
        };
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "sleep 0.1 && pavucontrol";
          on-click-right = "sleep 0.1 && blueman-manager";
        };
        "custom/exit" = {
          tooltip = false;
          format = "";
          on-click = "sleep 0.1 && wlogout";
        };
        "cava" = {
        framerate = 60;
        autosens = 1;
          #sensitivity = 20;
        bars = 10;
        lower_cutoff_freq = 50;
        higher_cutoff_freq = 12000;
        method = "pipewire";
        hide_on_silence = false;
        sleep_timer = 5;
        source = "auto";
        stereo = false;
        reverse = false;
        bar_delimiter = 0;
        monstercat = true;
        waves = true;
        noise_reduction = 0.77;
        input_delay = 2;
        format-icons = [
            "▁"
            "▂"
            "▃"
            "▄"
            "▅"
            "▆"
            "▇"
            "█"
          ];
        
        actions ={ 
            on-click-right = "mode";
          };
        };
        "custom/startmenu" = {
          tooltip = false;
          format = "";
          # exec = "rofi -show drun";
          on-click = "sleep 0.1 && rofi-launcher";
        };
        "custom/hyprbindings" = {
          tooltip = false;
          format = "󱕴";
          on-click = "sleep 0.1 && list-hypr-bindings";
        };
        #"idle_inhibitor" = {
        #  format = "{icon}";
        #  format-icons = {
        #    activated = "";
        #    deactivated = "";
        #  };
        #  tooltip = "true";
        #};
        "custom/notification" = {
          tooltip = false;
          format = "{icon} {}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && task-waybar";
          escape = true;
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          #on-click = "";
          interval = 5;
          format-time = "{H}h{M}m";
          tooltip = true;
          tooltip-format = "{time}";
         
        };
      }
    ];
    style = concatStrings [
      ''
        * {
          font-family: JetBrainsMono Nerd Font Mono;
          font-size: 16px;
          border-radius: 0px;
          border: none;
          min-height: 0px;
        }
        window#waybar {
          background: rgba(0,0,0,0);
        }
        #workspaces {
          color: #${config.stylix.base16Scheme.base00};
          background: #${config.stylix.base16Scheme.base01};
          margin: 0px 4px;
          padding: 8px 5px;
          border-radius: 0px 0px 16px 16px;
        }
        #workspaces button {
          font-weight: bold;
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: #${config.stylix.base16Scheme.base00};
          background: #${config.stylix.base16Scheme.base0A};
          opacity: 0.5;
          transition: ${betterTransition};
        }
        #workspaces button.active {
          font-weight: bold;
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: #${config.stylix.base16Scheme.base00};
          background: #${config.stylix.base16Scheme.base0A};
          transition: ${betterTransition};
          opacity: 1.0;
          min-width: 40px;
        }
        #workspaces button:hover {
          font-weight: bold;
          border-radius: 16px;
          color: #${config.stylix.base16Scheme.base00};
          background: #${config.stylix.base16Scheme.base0B};
          opacity: 0.8;
          transition: ${betterTransition};
        }
        tooltip {
          background: #${config.stylix.base16Scheme.base00};
          border: 1px solid #${config.stylix.base16Scheme.base0A};
          border-radius: 12px;
        }
        tooltip label {
          color: #${config.stylix.base16Scheme.base0A};
        }
        #clock, #window, #pulseaudio, #idle_inhibitor,
        #cava, #backlight, #custom-exit, #tray {
          font-weight: bold;
          margin: 4px 0px;
          margin-left: 7px;
          padding: 0px 18px;
          background: #${config.stylix.base16Scheme.base04};
          color: #${config.stylix.base16Scheme.base00};
          border-radius: 24px 10px 24px 10px;
        }
        #costom {
          font-weight: bold;
          color: #${config.stylix.base16Scheme.base0B};
          background: #${config.stylix.base16Scheme.base02};
          margin: 0px;
          padding: 0px 30px 0px 15px;
          border-radius: 0px 0px 40px 0px;
        }
        #custom-hyprbindings, #network, #battery,
        #custom-notification, #language, #cpu, #memory, #temperature {
          font-weight: bold;
          background: #${config.stylix.base16Scheme.base04};
          color: #${config.stylix.base16Scheme.base00};
          margin: 4px 0px;
          margin-right: 7px;
          border-radius: 10px 24px 10px 24px;
          padding: 0px 18px;
        }
         #custom-startmenu {
          font-size: 28px;
          color: #${config.stylix.base16Scheme.base0B};
          background: #${config.stylix.base16Scheme.base02};
          margin: 0px;
          padding: 0px 15px 0px 30px;
          border-radius: 0px 0px 0px 40px;
        }
      ''
    ];
  };
}
