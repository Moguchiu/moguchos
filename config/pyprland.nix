{ config, ... }:
 
{
 home.file.".config/hypr/pyprland.toml".text = ''
     
     [pyprland]
      plugins = [
      "scratchpads",
      ]

     [scratchpads.volume]
     animation = "fromRight"
     command = "pavucontrol"
     class = "org.pulseaudio.pavucontrol"
     size = "40% 90%"

     [scratchpads.blueman]
     animation = "fromLeft"
     command = "blueman-manager"
     class = ".blueman-manager-wrapped"
     size = "40% 90%"

    '';
}
