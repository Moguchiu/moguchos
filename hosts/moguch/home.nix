{
  pkgs,
  username,
  host,
  lib,
  inputs,
  ...
}:
let
  inherit (import ./variables.nix) gitUsername gitEmail;
in
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Import Program Configurations
  imports = [
    ../../config/emoji.nix
    ../../config/fastfetch
    ../../config/hyprland.nix
    ../../config/neovim.nix
    ../../config/rofi/rofi.nix
    ../../config/rofi/config-emoji.nix
    ../../config/rofi/config-long.nix
    #../../config/swaync.nix
    #../../config/waybar.nix
    #../../config/wlogout.nix
    ../../config/zsh/default.nix
    #../../config/pyprland.nix
    ../../config/rmpc.nix
  ];

  # Place Files Inside Home Directory
  home.file."Pictures/Wallpapers" = {
    source = ../../config/wallpapers;
    recursive = true;
  };
  home.file.".config/wlogout/icons" = {
    source = ../../config/wlogout;
    recursive = true;
  };
  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures/Screenshots  
    save_filename_format=swappy-%Y%m%d-%H%M%S.png    
    show_panel=false                                 
    line_size=5                                      
    text_size=20                                     
    text_font=Ubuntu                                 
    paint_mode=brush                                 
    early_exit=true                                  
    fill_shape=false                                 
  '';

  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Styling Options
  stylix.targets.waybar.enable = false;
  stylix.targets.rofi.enable = false;
  stylix.targets.hyprland.enable = false;
  gtk = {
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    style.name = lib.mkDefault "gruvbox-dark";
    platformTheme.name = lib.mkDefault "qt5ct";
  };
  xdg.configFile = {
  "qt5ct/qt5ct.conf".text = ''
    [Appearance]
    icon_theme = "Gruvbox-Plus-Dark"
  '';
  "qt6ct/qt6ct.conf".text = ''
    [Appearance]
    icon_theme = "Gruvbox-Plus-Dark"
  '';
  };

  # Scripts
  home.packages = [
    (import ../../scripts/emopicker9000.nix { inherit pkgs; })
    (import ../../scripts/task-waybar.nix { inherit pkgs; })
    (import ../../scripts/squirtle.nix { inherit pkgs; })
    (import ../../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ../../scripts/wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ../../scripts/web-search.nix { inherit pkgs; })
    (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../scripts/screenshootin.nix { inherit pkgs; })
    (import ../../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
    #pkgs.hyprpanel
    pkgs.zsh-powerlevel10k
    pkgs.zsh-fzf-tab
    pkgs.eza          # Для алиасов
    pkgs.bat          # Для `cat = bat`
    pkgs.zoxide       # Для умного cd 
      ];

  services = {
    
    hyprpaper = {
     enable = true;
     settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
      preload = [
        "~/moguchos/config/wallpapers/Hollow_Emblem.png"
        ];
      wallpaper = [
        " ,~/moguchos/config/wallpapers/Hollow_Emblem.png"
        ];
  };
};

  };

  programs = {
    superfile = {
       enable = true;
       settings = {
        theme = "gruvbox-dark-hard";
        default_sort_type = 0;
        transparent_background = true;
      };
    };
  obs-studio = {
    enable = true;

    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      wlrobs
      #obs-ndi
      waveform
      #obs-vaapi #optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
    ];
  };
    gh.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold
      '';
    };
     starship = {
            enable = true;
            package = pkgs.starship;
     };
    
    home-manager.enable = true;
   };
}
