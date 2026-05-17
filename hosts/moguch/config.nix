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
    pkgs.xdg-desktop-portal
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-wlr
    pkgs.xdg-desktop-portal-hyprland
  ];
in
{
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/local-hardware-clock.nix
  ];

  boot = {
    # Kernel
    #kernelPackages = pkgs.linuxPackages_zen;
    kernelPackages = pkgs.linuxPackages_latest;
    #kernelPackages = pkgs.linuxPackages_6_16;
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Appimage Support
    /*binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };*/
    supportedFilesystems = [ "fuse" ];
    plymouth.enable = true;
  };
    
  #battery
  powerManagement.enable = false;
  #tlp
  services = {
    power-profiles-daemon.enable = true;
    
    mullvad-vpn.enable = false;
    /*openvpn.servers = {
     protonVPN  = { config = '' config /home/moguch/moguchos/VPN/nl-free-14.protonvpn.udp.ovpn ''; };
    };*/
    
    system76-scheduler = {
     enable = true;
     package = pkgs.system76-scheduler;
     useStockConfig = true;
    };

    tlp = {
      enable = false;
      settings = {
        
        TLP_AUTO_SWITCH = 0;
        TLP_DEFAULT_MODE= "BAL";

        #WIFI_PWR_ON_AC= "off"; 
        #WIFI_PWR_ON_BAT= "off";
        #WOL_DISABLE = "N";

        #PLATFORM_PROFILE_ON_AC = "balanced";
        #PLATFORM_PROFILE_ON_BAT = "balanced";

        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 1;

       #Optional helps save long term battery health
       STOP_CHARGE_THRESH_BAT1 = 1; 

      };
    };
   };
   #Sleep
   systemd.sleep.settings.Sleep = {
     AllowSuspend = "no";
     AllowHibernation = "no";
     AllowHybridSleep = "no";
     AllowSuspendThenHibernate= "no";
     };
    

  # Styling Options
  stylix = {
    enable = true;
    image = ../../config/wallpapers/Hollow_Emblem.png;
       base16Scheme = {
     /* #Старое Gruvbox-dark
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
       */
      #Gruvbox-material-dark-hard
      base00 = "202020"; # bg
      base01 = "2a2827"; # bg2
      base02 = "504945"; # bg6
      base03 = "5a524c"; # bg8
      base04 = "bdae93"; # p-fg3
      base05 = "ddc7a1"; # fg
      base06 = "ebdbb2"; # p-fg1
      base07 = "fbf1c7"; # p-fg0
      base08 = "ea6962"; # red
      base09 = "e78a4e"; # orange
      base0A = "d8a657"; # yellow
      base0B = "a9b665"; # green
      base0C = "89b482"; # aqua/cyan
      base0D = "7daea3"; # blue
      base0E = "d3869b"; # purple
      base0F = "bd6f3e"; # dim-orange
    };
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        #package = pkgs.noto-fonts;
        #name = "Noto Font";
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
     memoryPercent = 99;
     priority = 100;
    };

  # Extra Module Options
  drivers.nvidia.enable = true;
  drivers.nvidia-prime.enable = true;
  local.hardware-clock.enable = false;

  # Enable networking
  networking.networkmanager.enable = true;
  # Wi-Fi и прошивки
  hardware.enableRedistributableFirmware = true;

  # Set your time zone.
  time.timeZone = "Europe/Minsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "${locale}";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${locale}";
    LC_IDENTIFICATION = "${locale}"; 
    LC_MEASUREMENT = "${localeT}";
    LC_MONETARY = "${localeT}";
    LC_NAME = "${locale}";
    LC_NUMERIC = "${localeT}";
    LC_PAPER = "${localeT}";
    LC_TELEPHONE = "${localeT}";
    LC_TIME = "${localeT}";
  };

  programs = {
   regreet.enable = false;
   nh = {
    enable = true;
    flake = "/home/moguch/moguchos";
   };
    /*appimage = {
      enable = true;
      binfmt = true;
    };*/
  hyprland = {
    enable = true;
    };
    firefox.enable = false;
    starship = {
      enable = true;
      settings = {
        add_newline = true;
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
    fuse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      extest.enable = true;
      fontPackages = with pkgs;[ 
         nerd-fonts.jetbrains-mono 
         ];
      #gamescopeSession.enable = true;
      #extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    gamemode.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
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
    #htop                       # Мониторинг ресурсов
    #yazi                       # Современный терминальный файловый менеджер  
    #neohtop                    # Мониторинг системы
    appimage-run               # Appimage
    #file                       #
    #squashfsTools              #
    #fuse3                      # Утилиты Appimage
    #icu                        #
    #zlib                       #
    fd                         # Современная версия find
    fish                       # Friendly Interactive SHell — альтернативная оболочка с удобным автодополнением, синтаксисом и поиском по истории.
    libpng
    gtk3
    
    # 🌐 Браузеры и интернет
    #vivaldi
    #vivaldi-ffmpeg-codecs
    

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
    curl                       # Утилита для передачи данных по URL-адресам
    jq                         # JSON-парсер и трансформер, позволяет фильтровать и форматировать JSON прямо в терминале
    #neofetch
    wlr-randr                  # Смотреть "входы" монитора
    libgtop                    # Library that reads information about processes and the running system
    dart-sass                  # Reference implementation of Sass, written in Dart
    gtksourceview3 #Binding to the GtkSourceView library
    libsoup_3                  #HTTP client/server library for GNOME
    dmidecode                  #Видеть модели железа
    hyprshutdown               #Закрытие приложений и выход из hyprland
    hyprcursor                 #Курсор Hyprland
    quickshell                 # Для запуска всяких шелов и приложений на Qt
    openvpn                    #Vpn connection
    #openresolv                 # DNS что-то там..
    #protonvpn-gui
    mullvad-vpn
 
    # ⚙️ Dev Tools
    pkg-config                 # Утилита для поиска флагов компиляции
    meson                      # Система сборки
    ninja                      # Быстрая сборка
    jdk8                       # Java Development Kit 8
    nixfmt                     # Форматирование nix-кода
    ntfs3g                     # Поддержка NTFS штук

    # 🎨 UI / Desktop утилиты
    #lxqt.lxqt-policykit        # Политика авторизации LXQt (интеграция pkexec)
    #bibata-cursors
    hyprpolkitagent             # авторизация (polikit)
    yad                        # Утилита для диалоговых окон
    #swaynotificationcenter     # Центр уведомлений для sway/hyprland
    brightnessctl              # Управление яркостью
    swappy                     # Утилита для скриншотов и аннотаций
    hyprpicker                 # Утилита для выбора цвета под Hyprland
    grim                       # Скриншоты
    slurp                      # Выбор области экрана
    #awww                       # Анимированная смена обоев
    file-roller                # Графический архиватор
    imv                        # Просмотр изображений
    #mpv                        # Медиаплеер
    pavucontrol                # Графическое управление звуком (PulseAudio)
    tuigreet            # Консольный логин-менеджер
    ddcutil                    # Инструмент для чтения и управления параметрами монитора через DDC/CI (яркость, контрастность и другие настройки экранов).
    imagemagick                # Набор инструментов для конвертации, трансформации, аннотирования и генерации растровых изображений из командной строки.
    pastel                     # Цвет и всякие штуки с ним
    #ashell                     # Bar?
    easyeffects

    # 🎮 Игры и графика
    #r2modman                   # менеджер модов 
    gimp                       # Редактор изображений
    #krita                      # Графический редактор
    qbittorrent                # Торрент-клиент
    calibre                    # Чтение и организация e-book
    #pandoc                     # Конвертация документов
    #focuswriter                # Фокусированное письмо
    #typora                     # Ещё один текстовый редактор
    #zettlr                     # Текстовый редактор
    obsidian                   # Система для управления связанными заметками
    #(blender.override ({ cudaSupport = true; })) # Blender с поддержкой CUDA
    (blender.override ({cudaSupport = true; }))
    /*(wrapOBS { 
      plugins = with obs-studio-plugins; [      
        # Плагин для захвата экрана в Wayland
        wlrobs
        # Другие полезные плагины
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vkcapture
        obs-vaapi
      ];
    })*/
    heroic                     # Установщик Epic/GoG игр
    protontricks               # Утилиты для Proton
    winetricks
    #lutris-free                # Менеджер игр под Linux
    discord
    #vesktop                    # discord launcher
    onlyoffice-desktopeditors  # офисный пакет
    telegram-desktop           # Десктопный Telegram-клиент.
    upscayl                    # Апскейлер изображений на основе ИИ
    godot                      # движок
    ryubing                    #Nintendo Switch emul
    eden
    tkmm                       #Totk modmanager
    dolphin-emu                #Gamecube/Wii/Triforce emul
    cemu                       #Wii U emul


    # 📎 Клипборд
    wl-clipboard               # Работа с Wayland буфером обмена
    cliphist                   # История буфера обмена

    # 🔊 Аудио / Bluetooth
    pipewire                   # Современный звуковой сервер
    wireplumber                # Session manager для PipeWire
    #bluez-alsa                 # Bluetooth с поддержкой ALSA
    #bluez-tools                # Bluetooth-утилиты
    #bluez
    #blueman                    # GUI для Bluetooth
    playerctl                  # Управление плеерами
    #spotify
    #cava                       #Console AV Audio visualizer — выводит график спектра звука прямо в терминале, работает через PipeWire/ALSA.
    #youtube-music              # Music

    # 🖥️ Виртуализация
    libvirt                    # Фреймворк виртуализации
    virt-viewer                # Просмотр виртуальных машин

    #🐍 Програмирование ИИ и всё такое
    /*python313Packages.aubio     #Python-привязки к библиотеке Aubio для анализа аудио (распознавание темпа, частотный анализ и т.п.).
    python313Packages.pyaudio   #Python-модуль для работы с аудио: запись и воспроизведение через PortAudio.
    python313Packages.numpy     #	Библиотека для научных вычислений в Python: многомерные массивы, линейная алгебра, статистика и т.п.
    python313                  # Python 3.13
    python313Packages.pip      # pip для 3.13
    python313Packages.virtualenv # Виртуальные окружения
    python313Packages.manim    # Анимации в математике
    manim                      # Manim CLI
    texlive.combined.scheme-full # LaTeX-пакеты (полный набор)
    (alpaca.override ({
     ollama = pkgs.ollama-cuda;
     }))                           # Gui для LLM
    */

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
    #scarab                     # Лаунчер с TUI-интерфейсом для Hollow knight
    
    # Icons
    /*
    qlementine-icons           # Vector icon set for modern desktop Qt5/Qt6 applications
    kdePackages.qtstyleplugin-kvantum  #SVG-based Qt5 theme engine plus a config tool and extra themes
    haskellPackages.svg-icons         
    */
    qt6.qtwayland
    qt6.qt5compat
    kdePackages.qtmultimedia
    #libsForQt5.qt5.qtmultimedia
    #libsForQt5.qt5ct
    glibc
    gccNGPackages_15.libstdcxx
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts 
      liberation_ttf 
      dejavu_fonts 
      font-awesome
      material-symbols
      nerd-fonts.jetbrains-mono
      ibm-plex
      symbola
      material-icons
      gruvbox-plus-icons
      adwaita-icon-theme
      papirus-icon-theme
      gnome-themes-extra
    
      hicolor-icon-theme
    ];
  };

 
  # Extra Portal Configuration
   xdg.portal = {
    enable = true;
    wlr.enable = true;
    #config.common.default = "*";
    xdgOpenUsePortal = true;
    extraPortals = myPortals;
    configPackages = myPortals;
  };

  
  # Services to start
  services = {
    upower.enable = true;
    dbus.enable = true;     # Simple interprocess messaging system
    seatd.enable = true;    # важно для wayland
    xserver.enable = false;
    greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
         user = "${username}";
         command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland"; # start Hyprland with a TUI login manager
          };
         };
    };
    fwupd = {
      enable = true;
        #daemonSettings = {
        #  DisableWatchdog = true;
        #   ApproveRestart = "never";
      #  };
    };    
    smartd = {
      enable = true;
      autodetect = true;
    };
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    #flatpak.enable = false;
    printing = {
      enable = false;
      drivers = [
        # pkgs.hplipWithPlugin
      ];
    };
    #gnome.gnome-keyring.enable = true;
    avahi = {
      enable = false;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
    };
    #Thunderbolt
    hardware.bolt.enable = true;
    
  };

  #Принтер
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };

  # Bluetooth Support
  hardware.bluetooth = { 
    enable = true;
    powerOnBoot = true;
   settings = {
    General = {
        Experimental = true;  # Включаем экспериментальные функции
        KernelExperimental = true;
        FastConnectable = true;
    };
    Policy = {
      AutoEnable = true;
    };
   };
  };
  services.blueman.enable = true;
 
  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  
  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      substituters = [
      "https://cache.nixos-cuda.org"
      ];
      trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];

      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Системные и basic
    stdenv.cc.cc icu glib zlib openssl expat systemd file xz

    # X11 / Wayland
    libxkbcommon libX11 libxcb
    libxcomposite libxtst libxrandr libxext
    libxfixes libxinerama libxcursor libxrender
    libxdamage libxshmfence libxxf86vm
    wayland wayland-protocols mesa libGL libGLU libva libvdpau
    pixman cairo freetype fontconfig pango gdk-pixbuf atk

    # Multimedia / Audio
    libpulseaudio pipewire alsa-lib ffmpeg libogg libvorbis flac
    speex libvpx libdrm

    # SDL / Игры
    SDL SDL2 SDL_image SDL2_image SDL_ttf SDL2_ttf SDL_mixer SDL2_mixer
    freeglut glew_1_10 libjpeg libpng libsamplerate libmikmod libtheora
    libtiff libcaca

    # GTK / Appindicator
    gtk3 gtk4 pango

    # Прочие утилиты
    libxi libsm libice libcap libusb1 libidn tbb nspr nss cups libudev0-shim
  ];    


  # OpenGL
  
    hardware.graphics = {
    #hardware.opengl = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ 
      nvidia-vaapi-driver
      libva-vdpau-driver
      libvdpau
      libvdpau-va-gl
      egl-wayland
      vdpauinfo
	    libva
		  libva-utils
      #Для AMD
      #amdvlk
    ];
  };

  console.keyMap = "us";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  #networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
