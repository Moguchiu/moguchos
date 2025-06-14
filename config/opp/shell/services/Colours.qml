pragma Singleton

import "root:/config"
import "root:/utils"
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property list<string> colourNames: ["rosewater", "flamingo", "pink", "mauve", "red", "maroon", "peach", "yellow", "green", "teal", "sky", "sapphire", "blue", "lavender"]

    property bool showPreview
    property bool endPreviewOnNextChange
    property bool light
    readonly property Colours palette: showPreview ? preview : current
    readonly property Colours current: Colours {}
    readonly property Colours preview: Colours {}
    readonly property Transparency transparency: Transparency {}

    function alpha(c: color, layer: bool): color {
        if (!transparency.enabled)
            return c;
        c = Qt.rgba(c.r, c.g, c.b, layer ? transparency.layers : transparency.base);
        if (layer)
            c.hsvValue = Math.max(0, Math.min(1, c.hslLightness + (light ? -0.2 : 0.2))); // TODO: edit based on colours (hue or smth)
        return c;
    }

    function on(c: color): color {
        if (c.hslLightness < 0.5)
            return Qt.hsla(c.hslHue, c.hslSaturation, 0.9, 1);
        return Qt.hsla(c.hslHue, c.hslSaturation, 0.1, 1);
    }

    function load(data: string, isPreview: bool): void {
        const colours = isPreview ? preview : current;
        for (const line of data.trim().split("\n")) {
            let [name, colour] = line.split(" ");
            name = name.trim();
            name = colourNames.includes(name) ? name : `m3${name}`;
            if (colours.hasOwnProperty(name))
                colours[name] = `#${colour.trim()}`;
        }

        if (!isPreview || (isPreview && endPreviewOnNextChange)) {
            showPreview = false;
            endPreviewOnNextChange = false;
        }
    }

    function setMode(mode: string): void {
        setModeProc.command = ["opp", "scheme", "dynamic", "default", mode];
        setModeProc.startDetached();
    }

    Process {
        id: setModeProc
    }

    
    component Transparency: QtObject {
        readonly property bool enabled: false
        readonly property real base: 0.78
        readonly property real layers: 0.58
    }
    component Colours: QtObject {
  // === M3 paletteKeyColors ===
property color m3primary_paletteKeyColor:       "#83a598" // глубокий сине-зелёный
property color m3secondary_paletteKeyColor:     "#b8bb26" // тёплый лайм
property color m3tertiary_paletteKeyColor:      "#d79921" // золотистый
property color m3neutral_paletteKeyColor:       "#665c54"
property color m3neutral_variant_paletteKeyColor: "#504945"

// === Backgrounds / Surfaces ===
property color m3background:                    "#1d2021"
property color m3onBackground:                  "#ebdbb2"
property color m3surface:                       "#282828"
property color m3surfaceDim:                    "#1b1b1b"
property color m3surfaceBright:                 "#3c3836"
property color m3surfaceContainerLowest:        "#1a1a1a"
property color m3surfaceContainerLow:           "#2a2a2a"
property color m3surfaceContainer:              "#3c3836"
property color m3surfaceContainerHigh:          "#4a4a4a"
property color m3surfaceContainerHighest:       "#504945"

// === Surface/OnSurface ===
property color m3onSurface:                     "#d5c4a1"
property color m3surfaceVariant:                "#504945"
property color m3onSurfaceVariant:              "#bdae93"

// === Inverse & Outline ===
property color m3inverseSurface:                "#ebdbb2"
property color m3inverseOnSurface:              "#1d2021"
property color m3outline:                       "#7c6f64"
property color m3outlineVariant:                "#665c54"
property color m3shadow:                        "#000000"
property color m3scrim:                         "#000000"
property color m3surfaceTint:                   "#83a598"

// === Primary Colors ===
property color m3primary:                       "#83a598"
property color m3onPrimary:                     "#1d2021"
property color m3primaryContainer:              "#689d6a"
property color m3onPrimaryContainer:            "#fbf1c7"
property color m3inversePrimary:                "#fabd2f"

// === Secondary Colors ===
property color m3secondary:                     "#b8bb26"
property color m3onSecondary:                   "#1d2021"
property color m3secondaryContainer:            "#98971a"
property color m3onSecondaryContainer:          "#fbf1c7"

// === Tertiary Colors ===
property color m3tertiary:                      "#d79921"
property color m3onTertiary:                    "#1d2021"
property color m3tertiaryContainer:             "#b57614"
property color m3onTertiaryContainer:           "#fbf1c7"

// === Error Colors ===
property color m3error:                         "#cc241d"
property color m3onError:                       "#fbf1c7"
property color m3errorContainer:                "#9d0006"
property color m3onErrorContainer:              "#fbf1c7"

// === Fixed Colors ===
property color m3primaryFixed:                  "#83a598"
property color m3primaryFixedDim:               "#689d6a"
property color m3onPrimaryFixed:                "#1d2021"
property color m3onPrimaryFixedVariant:         "#3c3836"

property color m3secondaryFixed:                "#b8bb26"
property color m3secondaryFixedDim:             "#98971a"
property color m3onSecondaryFixed:              "#1d2021"
property color m3onSecondaryFixedVariant:       "#504945"

property color m3tertiaryFixed:                 "#d79921"
property color m3tertiaryFixedDim:              "#b57614"
property color m3onTertiaryFixed:               "#1d2021"
property color m3onTertiaryFixedVariant:        "#3c3836"

// === Custom Accent Palette ===
property color rosewater:                       "#f2e5bc"
property color flamingo:                        "#fb4934"
property color pink:                            "#d3869b"
property color mauve:                           "#b16286"
property color red:                             "#cc241d"
property color maroon:                          "#9d0006"
property color peach:                           "#fe8019"
property color yellow:                          "#fabd2f"
property color green:                           "#b8bb26"
property color teal:                            "#8ec07c"
property color sky:                             "#83a598"
property color sapphire:                        "#076678"
property color blue:                            "#458588"
property color lavender:                        "#d5c4a1"
}
}
