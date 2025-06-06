
          exec-once = killall -q waybar;sleep .5 && waybar
          exec-once = killall -q swaync;sleep .5 && swaync
          exec-once = killall -q hyprpanel;sleep .5 && hyprpanel


           enable_hyprcursor = true
           env = HYPRCURSOR_THEME,Babita-Modern-Ice
           env = HYPRCURSOR_SIZE,24
           env = XCURSOR_THEME,Babita-Modern-Ice
           env = XCURSOR_SIZE,24
          
             animations {
            enabled = yes
            bezier = wind, 0.05, 0.9, 0.1, 1.05
            bezier = winIn, 0.1, 1.1, 0.1, 1.1
            bezier = winOut, 0.3, -0.3, 0, 1
            bezier = liner, 1, 1, 1, 1
            animation = windows, 1, 6, wind, slide
            animation = windowsIn, 1, 6, winIn, slide
            animation = windowsOut, 1, 5, winOut, slide
            animation = windowsMove, 1, 5, wind, slide
            animation = border, 1, 1, liner
            animation = fade, 1, 10, default
            animation = workspaces, 1, 5, wind
          }
          

