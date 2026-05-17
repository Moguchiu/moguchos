#
# Lightweight and customizable notifications.
# src: https://dunst-project.org/
#

{ config, lib, ... }:
/*let
  palette = config.lib.stylix.colors;
in*/ {
  services.dunst = {
    enable = true;

    # For settings: `man dunst.5`.
    # Also available here: https://github.com/dunst-project/dunst/blob/master/docs/dunst.5.pod
    # Default values: https://github.com/dunst-project/dunst/blob/master/dunstrc
    #
    # Cannot use symlink to ~/.config/dunst/dunstrc and ~/.config/dunst/dunstrc.d/*.conf, it seems
    # home-manager/nix is doing some stuff behind the scene that overrides the values...
    settings = {
      global = {
        # Display notification on focused monitor.  Possible modes are:
        #   mouse: follow mouse pointer
        #   keyboard: follow window with keyboard focus
        #   none: don't follow anything
        #
        # "keyboard" needs a window manager that exports the
        # _NET_ACTIVE_WINDOW property.
        # This should be the case for almost all modern window managers.
        #
        # If this option is set to mouse or keyboard, the monitor option
        # will be ignored.
        follow = "mouse";
        # Dynamic width of the notification window, from 0 to 300px.
        width = "(100,300)";
        # The maximum height of a single notification, excluding the frame.
        height = "(0, 300)";
        
        # Position the notification in the top right corner
        origin = "top-right";
        
        # Respectively the horizontal and vertical offset in pixels from the corner
        # of the screen specified by origin. A negative offset will lead to the notification being off screen.
        # Margin of 14px from the right and 50 pixels from the top.
        offset = "(25, 25)";

        # The distance in pixels from the content to the border of the window in the horizontal axis.
        horizontal_padding = 10;

        # Defines width in pixels of frame around the notification window.
        # Set to 0 to disable.
        frame_width = 2;

        # Defines color of the frame around the notification window.
        #frame_color = "#${palette.base05}";
        frame_color = "#a0a0a0"; 

        # Define the corner radius of the notification window
        # in pixel size. If the radius is 0, you have no rounded
        # corners.
        # The radius will be automatically lowered if it exceeds half of the
        # notification height to avoid clipping text and/or icons.
        corner_radius = 8;

        timeout = 4;
      
        #Text
        font = lib.mkDefault "JetBrainsMono Nerd Font Mono 12";
        
    ### Icons ###

    # Recursive icon lookup. You can set a single theme, instead of having to
    # define all lookup paths.
    enable_recursive_icon_lookup = true;

    # Set icon theme (only used for recursive icon lookup)
    icon_theme = "Gruvbox-Plus-Dark";
    # You can also set multiple icon themes, with the leftmost one being used first.
    

    # Align icons left/right/top/off
    icon_position = "left";

    # Scale small icons up to this size, set to 0 to disable. Helpful
    # for e.g. small files or high-dpi screens. In case of conflict,
    # max_icon_size takes precedence over this.
    min_icon_size = 32;

    # Scale larger icons down to this size, set to 0 to disable
    max_icon_size = 64;  

      };

      ##################
      # Specific rules #
      ##################

      urgency_low = lib.mkDefault {
        # Force color of the frame instead of the one from stylix.
        #frame_color = lib.mkForce "#${palette.base05}";
        # IMPORTANT: colors have to be defined in quotation marks.
        # Otherwise the "#" and following would be interpreted as a comment.
        background = "#222222";
         foreground = "#ffffff";
	       highlight = "#722ae6, #e4b5cb";
         timeout = 20;
        # Icon for notifications with low urgency
        #default_icon = dialog-information
      };
      urgency_normal = lib.mkDefault {
        # Force color of the frame instead of the one from stylix.
        #frame_color = lib.mkForce "#${palette.base05}";
        background = "#222222";
        foreground = "#ffffff";
      	frame_color = "#5e5086";
      	highlight = "#722ae6, #e4b5cb";
        timeout = 20;
        override_pause_level = 30;
        # Icon for notifications with normal urgency
        default_icon = "dialog-information";  
      };
      urgency_critical = lib.mkDefault {
        # Force color of the frame instead of the one from stylix.
        #frame_color = lib.mkForce "#${palette.base08}";
        #timeout = 0;
        background = "#222222";
        foreground = "#ffffff";
        frame_color = "#d54e53";
	      highlight = "#d54e53, #f0f0f0";
        timeout = 0;
        override_pause_level = 60;
        # Icon for notifications with critical urgency
        default_icon = "dialog-warning";
        
      };
    };
  };

}
