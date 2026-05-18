# FSR Enabler — Road to Vostok

A mod for **Road to Vostok** that enables AMD FidelityFX Super Resolution 2.2 (FSR2) with configurable quality presets and sharpness control — all through the Mod Configuration Menu. FSR2 is built into Godot 4 but not exposed to players by default. This mod unlocks it.

---

## How it works

Godot 4's Forward+ renderer includes FSR2 natively but the game does not expose it through its settings. This mod sets the viewport's scaling mode and resolution scale at runtime via GDScript, enabling FSR2 upscaling without modifying any game files. Settings persist between sessions and reapply automatically when changing maps or zones.

---

## Features

- **FSR2 upscaling** via 4 quality presets
- **Sharpness slider** — controls FSR2's built-in sharpening filter
- **Debug overlay** — shows active mode, render scale and sharpness on screen
- Settings saved automatically and restored on next launch
- **Reapplies automatically** when changing maps or zones — no need to re-enter the menu

---

## Requirements

- Road to Vostok (Steam)
- [Metro Mod Loader](https://modworkshop.net/mod/55623)
- [Mod Configuration Menu](https://modworkshop.net/mod/53713)

---

## Installation

1. Make sure Metro Mod Loader and MCM are installed
2. Download `fsr_enabler.vmz`
3. Drop it into your `mods/` folder:
   ```
   Road to Vostok/mods/fsr_enabler.vmz
   ```
4. Launch the game
5. Open MCM and look for **FSR Enabler**

---

## Presets

| Preset | Render Scale | Description |
|---|---|---|
| **Disabled** | 100% | FSR off, native rendering |
| **Native Quality** | 100% | FSR2 at native resolution — acts as high quality TAA |
| **Quality** | 77% | Best balance of quality and performance |
| **Balanced** | 67% | Good performance gain with acceptable quality |
| **Performance** | 50% | Maximum performance, lower image quality |

---

## Sharpness

The sharpness slider controls FSR2's built-in RCAS sharpening filter.

- `0.0` — no sharpening
- `1.0` — maximum sharpening

> Note: FSR2's sharpness API is inverted internally — the mod handles this automatically so the slider behaves intuitively.

---

## Debug Info

Enable the **Debug Info** checkbox in MCM to show an on-screen overlay with:

```
FSR Enabler | Mode: Quality | Scale: 77% | Sharpness: 0.75
```

Useful for verifying FSR is active after changing maps.

---

## Compatibility

Does not modify any game scripts, scenes or resources. Compatible with most mods including Visual Zone.

FSR2 works best alongside **SMAA** — which Road to Vostok has enabled by default. Do not combine with Godot's native TAA as they conflict.

---

## Notes

- **Native Quality** mode uses FSR2 at 100% scale as a high-quality temporal anti-aliasing solution — useful even without performance gains
- FSR2 is only available in the Forward+ renderer. Road to Vostok uses Forward+ so this mod is fully compatible
- The mod reapplies FSR automatically after map transitions using a staggered reapplication sequence — this is intentional and handles the game resetting viewport settings during scene loads

---

## Building from source

Requires [7-Zip](https://www.7-zip.org/) installed at the default path.

1. Clone the repository
2. Open a terminal inside the `fsr_enabler/` folder
3. Run `build.bat`
4. `fsr_enabler.vmz` will be created and copied automatically to your `mods/` folder

---

## Project structure

```
fsr_enabler/
├── mod.txt       — mod metadata and autoload declarations
├── Config.gd     — MCM registration and settings definition
├── Main.gd       — FSR runtime application and scene change handling
└── build.bat     — packaging script
```

---

## Planned features

- DLSS support investigation (NVIDIA equivalent)
- Per-scene profile support

---

## License

MIT — free to use, modify and redistribute with attribution.

---

## Credits

FSR2 implementation based on Godot 4's native RenderingServer and Viewport APIs.  
MCM integration pattern based on community modding standards for Road to Vostok.
