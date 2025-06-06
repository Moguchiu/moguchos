{
  config,
  pkgs,
  host,
  username,
  options,
  lib,
  ...
}:
let
  inherit (import ./variables.nix) keyboardLayout locale localeT browser;
  myPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-wlr
    pkgs.xdg-desktop-portal-hyprland
  ];
in
{
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  boot = {
    # Kernel
    #kernelPackages = pkgs.linuxPackages_zen;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "acpi_backlight=nvidia_wmi_ec_backlight"
      "systemd.mask=dev-tpmrm0.device" #this is to mask that stupid 1.5 mins systemd bug
      "nowatchdog" 
      "modprobe.blacklist=sp5100_tco" #nowatchdog for AMD
     ];

      # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };
    
  #Power-profile
  services.power-profiles-daemon.enable = false;
  #powerManagement.enable = true;
  
  #tlp
  services.tlp = {
      enable = true;
      settings = {
       WIFI_PWR_ON_AC = "off";
       WIFI_PWR_ON_BAT = "off";
       WOL_DISABLE = "N";
      
       PLATFORM_PROFILE_ON_AC = "performance";
       PLATFORM_PROFILE_ON_BAT = "balance";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "default";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      
       # Для интегрированной AMD GPU
       RADEON_DPM_STATE_ON_AC = "performance";
       RADEON_DPM_STATE_ON_BAT = "battery";

       # Для NVIDIA
       NVIDIA_DYNAMIC_POWER_MANAGEMENT = 1;

       CPU_MIN_PERF_ON_AC = 0;
       CPU_MAX_PERF_ON_AC = 100;
       CPU_MIN_PERF_ON_BAT = 0;
       CPU_MAX_PERF_ON_BAT = 100;
       
       CPU_BOOST_ON_AC = 1;
       CPU_BOOST_ON_BAT = 0;

       RESTORE_DEVICE_STATE_ON_STARTUP = 0;

       #Optional helps save long term battery health
       STOP_CHARGE_THRESH_BAT0 = 1; 

      };
    };

   #Sleep
   systemd.sleep.extraConfig = ''
     AllowSuspend=no
     AllowHibernation=no
     AllowHybridSleep=no
     AllowSuspendThenHibernate=no
     '';
    

  # Styling Options
  stylix = {
    enable = true;
    image = ../../config/wallpapers/Hollow_Emblem.png;
    #base16Scheme = "${pkgs.base16-schemes}/base16/gruvbox-dark-hard.yaml";
      base16Scheme = {
       base00 = "1d2021"; # ----
       base01 = "3c3836"; # ---
       base02 = "504945"; # --
       base03 = "a89984"; # -
       base04 = "bdae93"; # +
       base05 = "d5c4a1"; # ++
       base06 = "ebdbb2"; # +++
       base07 = "fbf1c7"; # ++++
       base08 = "fb4934"; # red
       base09 = "fe8019"; # orange
       base0A = "fabd2f"; # yellow
       base0B = "b8bb26"; # green
       base0C = "8ec07c"; # aqua/cyan
       base0D = "83a598"; # blue
       base0E = "d3869b"; # purple
       base0F = "d65d0e"; # brown
    };
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        #package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  #ZramSwap
   zramSwap = {
     enable = true;
     algorithm = "zstd";
     memoryPercent = 50;
    #priority = 999;
    };

  # Extra Module Options
  drivers.amdgpu.enable = false;
  drivers.nvidia.enable = true;
  drivers.nvidia-prime = {
    enable = true;
    #amdgpuBusID = "";
    #nvidiaBusID = "";
  };
  drivers.intel.enable = false;
  vm.guest-services.enable = false;
  local.hardware-clock.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = host;
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  # Wi-Fi и прошивки
  hardware.enableRedistributableFirmware = true;

  # Set your time zone.
  time.timeZone = "Europe/Minsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "${locale}";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${locale}";
    LC_IDENTIFICATION = "${locale}"; 
    LC_MEASUREMENT = "${locale}";
    LC_MONETARY = "${locale}";
    LC_NAME = "${locale}";
    LC_NUMERIC = "${locale}";
    LC_PAPER = "${locale}";
    LC_TELEPHONE = "${locale}";
    LC_TIME = "${localeT}";
  };

  programs = {
    firefox.enable = true;
    starship = {
      enable = false;
      settings = {
        add_newline = false;
        buf = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        directory = {
          read_only = " 󰌾";
        };
        docker_context = {
          symbol = " ";
        };
        fossil_branch = {
          symbol = " ";
        };
        git_branch = {
          symbol = " ";
        };
        golang = {
          symbol = " ";
        };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        lua = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        nim = {
          symbol = "󰆥 ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        ocaml = {
          symbol = " ";
        };
        package = {
          symbol = "󰏗 ";
        };
        python = {
          symbol = " ";
        };
        rust = {
          symbol = " ";
        };
        swift = {
          symbol = " ";
        };
        zig = {
          symbol = " ";
        };
      };
    };
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
    #gamemode.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true; 
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.cudaSupport = true;

  users = {
    mutableUsers = true;
  };

   #environment.sessionVariables = {
   # Общие
   #};

  environment.systemPackages = with pkgs; [
    # 📦 Базовые CLI-инструменты
    base16-schemes             # Цветовые схемы Base16
    vim                        # Текстовый редактор
    wget                       # Скачивание файлов по сети
    killall                    # Завершение процессов по имени
    eza                        # Улучшенный ls
    git                        # Система контроля версий
    cmatrix                    # Анимация "Матрицы" в терминале
    lolcat                     # Радужный вывод текста
    htop                       # Мониторинг ресурсов
    yazi                       # Современный терминальный файловый менеджер
    neohtop                    # Мониторинг системы

    # 🌐 Браузеры и интернет
    #brave                      # Браузер Brave
    (vivaldi.override {
     proprietaryCodecs = true;    # Включает проприетарные кодеки
     enableWidevine = true;       # DRM-поддержка (Netflix, Spotify)
     
     commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--gtk-version=4"
      ];
    })
    vivaldi-ffmpeg-codecs
    

    # 🧰 Системные утилиты
    xdg-utils                 # Приложения по умолчанию 
    lm_sensors                 # Мониторинг температуры и сенсоров
    unzip                      # Распаковка .zip
    unrar                      # Распаковка .rar
    libnotify                  # Уведомления
    v4l-utils                  # Работа с видео-устройствами (V4L)
    ydotool                    # Симуляция ввода мыши/клавиатуры
    duf                        # Просмотр использования диска
    ncdu                       # Анализ дискового пространства
    pciutils                   # Информация о PCI-устройствах
    lshw                       # Подробная информация об оборудовании
    ripgrep                    # Поиск по файлам (аналог grep, но быстрее)
    socat                      # Работа с сокетами
    bat                        # Улучшенный `cat` с подсветкой синтаксиса
    tree                       # Древовидный вывод директорий
    cowsay                     # Корова говорит
    

    # ⚙️ Dev Tools
    pkg-config                 # Утилита для поиска флагов компиляции
    meson                      # Система сборки
    ninja                      # Быстрая сборка
    jdk8                       # Java Development Kit 8
    nh                         # Утилита для управления nixos-конфигами
    nixfmt-rfc-style           # Форматирование nix-кода

    # 🎨 UI / Desktop утилиты
    lxqt.lxqt-policykit        # Политика авторизации LXQt (интеграция pkexec)
    yad                        # Утилита для диалоговых окон
    swaynotificationcenter     # Центр уведомлений для sway/hyprland
    brightnessctl              # Управление яркостью
    swappy                     # Утилита для скриншотов и аннотаций
    hyprpicker                 # Утилита для выбора цвета под Hyprland
    grim                       # Скриншоты
    slurp                      # Выбор области экрана
    #swww                       # Анимированная смена обоев
    file-roller                # Графический архиватор
    imv                        # Просмотр изображений
    mpv                        # Медиаплеер
    pavucontrol                # Графическое управление звуком (PulseAudio)
    greetd.tuigreet            # Консольный логин-менеджер
    #pyprland                   # Hyprland улучшения

    # 🎮 Игры и графика
    gimp                       # Редактор изображений
    krita                      # Графический редактор
    qbittorrent                # Торрент-клиент
    calibre                    # Чтение и организация e-book
    pandoc                     # Конвертация документов
    focuswriter                # Фокусированное письмо
    typora                     # Ещё один текстовый редактор
    zettlr                     # Текстовый редактор
    obsidian                   # Система для управления связанными заметками
    (blender.override ({ cudaSupport = true; })) # Blender с поддержкой CUDA
    heroic                     # Установщик Epic/GoG игр
    protontricks               # Утилиты для Proton
    lutris-free                # Менеджер игр под Linux
    discord
    vesktop                    # discord launcher
    onlyoffice-desktopeditors  # офисный пакет
    telegram-desktop           # Десктопный Telegram-клиент.
    upscayl                    # Апскейлер изображений на основе ИИ

    # 📎 Клипборд
    wl-clipboard               # Работа с Wayland буфером обмена
    cliphist                   # История буфера обмена

    # 🔊 Аудио / Bluetooth
    pipewire                   # Современный звуковой сервер
    wireplumber                # Session manager для PipeWire
    bluez-alsa                 # Bluetooth с поддержкой ALSA
    bluez-tools                # Bluetooth-утилиты
    blueman                    # GUI для Bluetooth
    playerctl                  # Управление плеерами
    spotify

    # 🖥️ Виртуализация
    libvirt                    # Фреймворк виртуализации
    virt-viewer                # Просмотр виртуальных машин

    #🐍 Програмирование ИИ и всё такое
    #python313                  # Python 3.13
    #python313Packages.pip      # pip для 3.13
    #python313Packages.virtualenv # Виртуальные окружения
    #python313Packages.manim    # Анимации в математике
    #manim                      # Manim CLI
    #texlive.combined.scheme-full # LaTeX-пакеты (полный набор)
    (alpaca.override ({
     ollama = pkgs.ollama-cuda;
      }))                           # Gui для LLM


    # 🧠 IDE и редакторы
    neovide                    # GUI для Neovim
      # (vscode-with-extensions.override {
      #  vscodeExtensions = with vscode-extensions; [
      #   ms-python.python
      #   ms-azuretools.vscode-docker
      #    ms-toolsai.jupyter
    # ];
    #  })                         # VSCode с расширениями

    # 🖥️ Мониторинг и прочее
    nvidia-system-monitor-qt   # Мониторинг для NVIDIA
    inxi                       # Подробная инфа о системе
    scarab                     # Лаунчер с TUI-интерфейсом для Hollow knight
    
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
      # Commenting Symbola out to fix install this will need to be fixed or an alternative found.
      # symbola
      material-icons
    ];
  };

  # Extra Portal Configuration
   xdg.portal = {
    enable = true;
    #wlr.enable = true;
    #config.common.default = "*";
    xdgOpenUsePortal = true;
    extraPortals = myPortals;
    configPackages = myPortals;
  };

  
  # Services to start
  services = {
    tailscale.enable = false;
    fwupd.enable = true;
    xserver = {
      enable = false;
      xkb = {
        layout = "${keyboardLayout},ru";
        variant = "";
        };
    };
      greetd = {
      enable = true;
      vt = 3;
      settings = {
      default_session = {
      user = "${username}";
         command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland"; # start Hyprland with a TUI login manager
      };
      };
    };
    smartd = {
      enable = false;
      autodetect = true;
    };
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    openssh.enable = true;
    #flatpak.enable = false;
    printing = {
      enable = true;
      drivers = [
        # pkgs.hplipWithPlugin
      ];
    };
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    syncthing = {
      enable = false;
      user = "${username}";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
    };

    rpcbind.enable = false;
    nfs.server.enable = false;
    #Thunderbolt
    hardware.bolt.enable = true;
    
  };
  
  #musnixix
   musnix = {
    enable = true;
   };

      hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };

  # Extra Logitech Support
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

  # Bluetooth Support
  hardware.bluetooth = { 
    enable = true;
    powerOnBoot = true;
   settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
        Experimental = true;  # Включаем экспериментальные функции
        KernelExperimental = true;
        #FastConnectable = true;
        AutoEnable = true;
    };
   };
  };
  services.blueman.enable = true;
  
  # Enable sound with pipewire.
  #services.pulseaudio.enable = false;
  

  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  
  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # Virtualization / Containers
  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

   #nix-ld
  #nixpkgs.config.permittedInsecurePackages = [
  # "dotnet-runtime-7.0.20"
  # "dotnet-sdk-wrapped-6.0.428" 
  # "dotnet-sdk-6.0.428"
  #];  
  programs.nix-ld.enable = true;
   programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    attr
    libssh
    bzip2
    libxml2
    acl
    libsodium
    xz
    util-linux
    systemd  
   ];    


  # OpenGL
  
    hardware.graphics = {
    #hardware.opengl = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ 
      nvidia-vaapi-driver
      vaapiVdpau
      libvdpau
      libvdpau-va-gl
      egl-wayland
      vdpauinfo
	    libva
		  libva-utils
      #Для AMD
      amdvlk
    ];
  };

  console.keyMap = "us";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
