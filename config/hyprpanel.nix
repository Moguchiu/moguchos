{ inputs,
  pkgs,
  lib,
  host,
  config,
  ... }:
{
  programs.hyprpanel = {
    enable = true;
    #package = inputs.hyprpanel.packages.${pkgs.system}.default;
    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {
     bar.battery.label = true;
     
     bar.bluetooth.label = false;
     
     bar.clock.format = "%H:%M";
     
     bar.launcher.autoDetectIcon = true;
      
     bar.layouts = {
      "*" = {
       left = [
        "dashboard"
        "workspaces"
        "media"
       ];
       middle = [ 
            "windowtitle"
          ];
       right = [
        "volume"
        "network"
        "bluetooth"
        "notifications"
        "clock"  
        "battery" 
      ];
      };
    };
      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };
     

    };
  };
}
