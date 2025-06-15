{
  lib,
  username,
  host,
  config,
  ...
}:

let
  inherit (import ../hosts/${host}/variables.nix)
    browser
    terminal
    extraMonitorSettings
    keyboardLayout
    ;
in
with lib;
{
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      animations = {
      enabled = true;
      bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92 "
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
          "md2, 0.4, 0, 0.2, 1 # use with .2s duration"
      ];
      animation = [
         "windows, 1, 3, md3_decel, popin 60%"
          "windowsIn, 1, 3, md3_decel, popin 60%"
          "windowsOut, 1, 3, md3_accel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          "layersIn, 1, 3, menu_decel, slide"
          "layersOut, 1, 1.6, menu_accel"
          "fadeLayersIn, 1, 2, menu_decel"
          "fadeLayersOut, 1, 4.5, menu_accel"
          "workspaces, 1, 7, menu_decel, slide"
          ];
      };
      
      env = [
        "NIXOS_OZONE_WL,1"
        "NIXPKGS_ALLOW_UNFREE,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "GDK_BACKEND,wayland,x11"
        "CLUTTER_BACKEND,wayland"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "SDL_VIDEODRIVER,x11"     
        "MOZ_ENABLE_WAYLAND,1"
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "GBM_BACKEND, nvidia-drm"
        "WLR_DRM_NO_ATOMIC,1"
        "WLR_DRM_NO_MODIFIERS,1"
      ];
      
      exec-once = [
        "dbus-update-activation-environment --systemd --all"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "killall -q pypr;sleep 0.5 && pypr"
        #"killall -q waybar;sleep 0.5 && waybar"
        #"killall -q swaync;sleep 0.5 && swaync"          
        "sleep 0.5 && kitty ~/moguchos/config/opp/shell/run.fish"
        "nm-applet --indicator"
        "lxqt-policykit-agent"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store" 
        "wl-clip-persist --clipboard regular --display wayland-1"
        "killall -q blueman-tray;sleep 1.5 && blueman-tray"
       ];

      general = {
        gaps_in = 6;
        gaps_out = 20;
        border_size = 2;
        layout = "dwindle";
        resize_on_border = true;
        "col.active_border" = "rgb(${config.stylix.base16Scheme.base0A}) rgb(${config.stylix.base16Scheme.base0C}) 45deg";
        "col.inactive_border" = "rgb(${config.stylix.base16Scheme.base01})";
       };
       
      input = {
        kb_layout = "${keyboardLayout}";
        kb_options = [
        "grp:alt_shift_toggle"
        ];
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.8;
          };
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat";
       };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };
 
      misc = {
        initial_workspace_tracking = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
        disable_hyprland_logo = true;
        animate_manual_resizes = true;
        new_window_takes_over_fullscreen = 1;
        vfr = true;
        
      };

      decoration = {
        rounding = 20;
        shadow = {
          enabled = false;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
          };
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = false
            ;
        };
      };
      
      cursor = {
        sync_gsettings_theme = true;
        no_hardware_cursors = true;
      };

      dwindle = {
        pseudotile = true;
         preserve_split = true;
      };
     
    };
    extraConfig =
      let
        modifier = "SUPER";
      in
      concatStrings [
        ''
         monitor =,preferred,auto,1.0
          ${extraMonitorSettings}
          windowrule = noborder, class:^(wofi)$
          windowrule = center, class:^(wofi)$
          windowrulev2 = opacity 0.9 0.7, class:^(thunar)$
          windowrulev2 = opacity 0.9 0.7, class:^(neovide)$
          windowrulev2 = opacity 0.9 0.7, class:^(vim)$
          windowrulev2 = opacity 0.9 0.7, class:^(${terminal})$
                    
          bind = ${modifier},Return,exec,${terminal}
          bind = ${modifier}SHIFT,Return,exec,rofi-launcher
          bind = ${modifier}SHIFT,W,exec,web-search
          bind = ${modifier}ALT,W,exec,wallsetter
          bind = ${modifier}SHIFT,N,exec,swaync-client -rs
          bind = ${modifier},W,exec,${browser}
          bind = ${modifier},E,exec,emopicker9000
          bind = ${modifier},S,exec,screenshootin
          bind = ${modifier},D,exec,discord
          bind = ${modifier},O,exec,obs
          bind = ${modifier},C,exec,hyprpicker -a
          bind = ${modifier},G,exec,gimp
          bind = ${modifier}SHIFT,G,exec,godot4
          bind = ${modifier},T,exec,thunar
          bind = ${modifier},M,exec,spotify
          bind = ${modifier},Q,killactive,
          bind = ${modifier},P,pseudo,
          bind = ${modifier}SHIFT,I,togglesplit,
          bind = ${modifier},F,fullscreen,
          bind = ${modifier}SHIFT,F,togglefloating,
          bind = ${modifier}SHIFT,C,exit,
          bind = ${modifier}SHIFT,left,movewindow,l
          bind = ${modifier}SHIFT,right,movewindow,r
          bind = ${modifier}SHIFT,up,movewindow,u
          bind = ${modifier}SHIFT,down,movewindow,d
          bind = ${modifier}SHIFT,h,movewindow,l
          bind = ${modifier}SHIFT,l,movewindow,r
          bind = ${modifier}SHIFT,k,movewindow,u
          bind = ${modifier}SHIFT,j,movewindow,d
          bind = ${modifier},left,movefocus,l
          bind = ${modifier},right,movefocus,r
          bind = ${modifier},up,movefocus,u
          bind = ${modifier},down,movefocus,d
          bind = ${modifier},h,movefocus,l
          bind = ${modifier},l,movefocus,r
          bind = ${modifier},k,movefocus,u
          bind = ${modifier},j,movefocus,d
          bind = ${modifier},1,workspace,1
          bind = ${modifier},2,workspace,2
          bind = ${modifier},3,workspace,3
          bind = ${modifier},4,workspace,4
          bind = ${modifier},5,workspace,5
          bind = ${modifier},6,workspace,6
          bind = ${modifier},7,workspace,7
          bind = ${modifier},8,workspace,8
          bind = ${modifier},9,workspace,9
          bind = ${modifier},0,workspace,10
          bind = ${modifier}SHIFT,SPACE,movetoworkspace,special
          bind = ${modifier},SPACE,togglespecialworkspace
          bind = ${modifier}SHIFT,1,movetoworkspace,1
          bind = ${modifier}SHIFT,2,movetoworkspace,2
          bind = ${modifier}SHIFT,3,movetoworkspace,3
          bind = ${modifier}SHIFT,4,movetoworkspace,4
          bind = ${modifier}SHIFT,5,movetoworkspace,5
          bind = ${modifier}SHIFT,6,movetoworkspace,6
          bind = ${modifier}SHIFT,7,movetoworkspace,7
          bind = ${modifier}SHIFT,8,movetoworkspace,8
          bind = ${modifier}SHIFT,9,movetoworkspace,9
          bind = ${modifier}SHIFT,0,movetoworkspace,10
          bind = ${modifier}CONTROL,right,workspace,e+1
          bind = ${modifier}CONTROL,left,workspace,e-1
          bind = ${modifier},mouse_down,workspace, e+1
          bind = ${modifier},mouse_up,workspace, e-1
          bindm = ${modifier},mouse:272,movewindow
          bindm = ${modifier},mouse:273,resizewindow
          
          bind = ${modifier}, X, global,opp:session
       
          bind = ALT,Tab,cyclenext
          bind = ALT,Tab,bringactivetotop
          bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
          bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          bind = ,XF86AudioPlay, exec, playerctl play-pause
          bind = ,XF86AudioPause, exec, playerctl play-pause
          bind = ,XF86AudioNext, exec, playerctl next
          bind = ,XF86AudioPrev, exec, playerctl previous
          bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
          bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
          ''
      ];
  };
}
