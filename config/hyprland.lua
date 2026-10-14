-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- Самая важная секция, особенно для гибридной графики.
-- Переменные применяются до инициализации композитора, поэтому их место здесь.

-- 1. Переменные для гибридной графики
-- Указываем порядок GPU. Первым должен быть встроенный AMD для рендеринга рабочего стола.
-- Это экономит заряд батареи и обеспечивает стабильность.
-- Замени пути на свои, если они отличаются (проверь командой `ls /dev/dri/by-path/`).
--hl.env("AQ_DRM_DEVICES", "/dev/dri/by-path/pci-0000:06:00.0-card:/dev/dri/by-path/pci-0000:01:00.0-card") 

-- Если монитор ноутбука не включается, раскомментируй следующую строку:
-- hl.env("AQ_DRM_NO_ATOMIC", "1") 

-- Переменные для VA-API аппаратного ускорения видео на NVIDIA (если установлен nvidia-vaapi-driver)
--hl.env("NVD_BACKEND", "direct")
--hl.env("LIBVA_DRIVER_NAME", "nvidia")

-- 2. Общие переменные для Wayland и тулкитов
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

--hl.env("GDK_BACKEND", "wayland,x11")  -- Приоритет Wayland для GTK приложений
--hl.env("QT_QPA_PLATFORM", "wayland;xcb") -- Приоритет Wayland для Qt приложений
--hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
--hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
--hl.env("CLUTTER_BACKEND", "wayland")
--hl.env("SDL_VIDEODRIVER", "wayland") -- Для игр и мультимедиа
hl.env("NIXOS_OZONE_WL", "1") -- актуально только для NixOS


------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",          -- Оставь пустым для автоматического определения всех мониторов
    mode     = "preferred", -- Родное разрешение и частота
    position = "auto",      -- Автоматическое расположение
    scale    = "1.0",      -- Автоматический скейлинг. С 0.55 можно использовать 'auto'.
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi-launcher"
local browser     = "zen"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
    -- Системные сервисы (запускаем асинхронно, `&` не нужен)
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Фоновые процессы
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-tray") -- blueman-applet тоже вариант
    
    -- Уведомления: лучше положиться на D-Bus активацию или systemd юнит, но можно и так
    -- hl.exec_cmd("killall -q dunst; sleep 0.5 && dunst") -- Оставь, если dunst не запускается сам
    
    -- Буфер обмена
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("wl-clip-persist --clipboard regular --display wayland-1")
end)


-----------------------
----- PERMISSIONS -----
-----------------------

-- Включаем систему прав (опционально)
--hl.config({
--  ecosystem = {
--   enforce_permissions = true,
--  },
--})

-- Разрешаем скриншоты и запись экрана для стандартных утилит
--hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })
--hl.permission({ binary = "/usr/bin/wl-screenrec", type = "screencopy", mode = "allow" })
--hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 0,

        border_size = 2,

        col = {
            active_border   = "rgb(bdae93)",
            inactive_border = "rgb(2a2827)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 0,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 0.7,

        shadow = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 5,
            passes    = 3,
            new_optimizations = true,
            vibrancy  = 0.1696,
        },
    },
---------------
---- INPUT ----
---------------
    input = {
        kb_layout  = "us, ru",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:alt_shift_toggle",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0.4, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },

    gestures = {
        workspace_swipe_forever = true,
    };
    

    animations = {
        enabled = true,
    },
})

-- === КРИВЫЕ ===

hl.curve("easeOutQuint", {
    type = "bezier",
    points = { {0.23, 1}, {0.32, 1} },
})

hl.curve("easeInOutCubic", {
    type = "bezier",
    points = { {0.65, 0.05}, {0.36, 1} },
})

hl.curve("linear", {
    type = "bezier",
    points = { {0, 0}, {1, 1} },
})

hl.curve("almostLinear", {
    type = "bezier",
    points = { {0.5, 0.5}, {0.75, 1} },
})

hl.curve("quick", {
    type = "bezier",
    points = { {0.15, 0}, {0.1, 1} },
})

hl.curve("menu_decel", {
    type = "bezier",
    points = { {0.1, 1}, {0, 1} },
})

hl.curve("easy", {
    type = "spring",
    mass = 1,
    stiffness = 71.2633,
    dampening = 15.8273644,
})

-- === АНИМАЦИИ ===

-- Глобальный контекст (всё, что не задано явно)
hl.animation({
    leaf = "global",
    enabled = true,
    speed = 10,
    bezier = "default",
})

-- Границы окон
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 5.39,
    bezier = "easeOutQuint",
})

-- Окна: открытие, закрытие, перемещение
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 4.79,
    spring = "easy",
})

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 4.1,
    spring = "easy",
    style = "popin 87%",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.49,
    bezier = "linear",
    style = "popin 87%",
})

-- Затухания
hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 1.73,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 1.46,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 3.03,
    bezier = "quick",
})

-- Слои (waybar, rofi, уведомления)
hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 3.81,
    bezier = "easeOutQuint",
})

hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint",
    style = "fade",
})

hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 1.5,
    bezier = "linear",
    style = "fade",
})

hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 1.79,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 1.39,
    bezier = "almostLinear",
})

-- Рабочие столы (плавное переключение)
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 7,
    bezier = "menu_decel",
    style = "slide",
})

hl.animation({
    leaf = "workspacesIn",
    enabled = true,
    speed = 7,
    bezier = "menu_decel",
    style = "slide",
})

hl.animation({
    leaf = "workspacesOut",
    enabled = true,
    speed = 7,
    bezier = "menu_decel",
    style = "slide",
})

-- Зум (для скриншотов и т.п.)
hl.animation({
    leaf = "zoomFactor",
    enabled = true,
    speed = 7,
    bezier = "quick",
})
-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
      preserve_split = true, -- You probably want this
    },
    cursor = {
        sync_gsettings_theme = true;
        no_hardware_cursors = false;
      };
    })

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        mouse_move_enables_dpms = true,
        initial_workspace_tracking = 0,
        animate_manual_resizes = true,
    },
})



hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
--hl.device({
--    name        = " ",
--    sensitivity = -0.5,
--})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
--hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("screenshootin"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("easyeffects", { workspace = "1 silent" }))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pavucontrol", { workspace = "1 silent" }))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("kitty btop", { workspace = "1 silent" }))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(browser, { workspace = "2 silent" }))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("obsidian", { workspace = "3 silent" }))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("Telegram", { workspace = "4 silent" }))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("vesktop", { workspace = "4 silent" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
--hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
--hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

