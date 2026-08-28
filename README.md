# 🖱️ Mouse FX Pro+

<p align="center">
  <img alt="Lua" src="https://img.shields.io/badge/Lua-G%20HUB%20Script-2C2D72?style=for-the-badge&logo=lua&logoColor=white">
  <img alt="Platform" src="https://img.shields.io/badge/Platform-Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white">
  <img alt="Logitech G HUB" src="https://img.shields.io/badge/Logitech-G%20HUB-00B8FC?style=for-the-badge">
  <img alt="Version" src="https://img.shields.io/badge/Version-1.4-red?style=for-the-badge">
</p>

<p align="center">
  <b>Mouse FX Pro+</b> is a Logitech G HUB Lua script with nine configurable mouse movement modes.<br>
  Select a mode with <b>M2/M3 + G-key</b>, then hold the <b>left mouse button</b> on the corresponding M-key layer to run it.
</p>

---

## 📌 Overview

Mouse FX Pro+ combines recoil control, cursor centering, and several geometric movement patterns in one Logitech G HUB script. It is intended for supported Logitech devices with Lua scripting, G-keys, and M-key layers.

The built-in status log shows the current event, M-key layer, active mode, toggle states, and cursor position. This makes the script useful for:

- experimenting with Logitech G HUB's Lua API
- testing relative and absolute mouse movement
- tuning configurable motion patterns
- learning how to structure a multi-mode G HUB script

---

## ✨ Features

| Layer | Mode | Behavior |
|---|---|---|
| M2 | 🎯 Recoil | Applies downward movement with smoothed random jitter |
| M2 | 📍 Center | Repeatedly moves the cursor to the virtual screen center |
| M2 | 🌀 Spiral | Draws a spiral that expands and contracts |
| M2 | ♾️ Infinity | Draws a horizontal figure-eight |
| M2 | ⭕ Circle | Draws a circular path |
| M3 | 🥚 Ellipse | Draws an ellipse with independent horizontal and vertical radii |
| M3 | 💎 Diamond | Draws a diamond-shaped path |
| M3 | ❤️ Heart | Draws a parametric heart |
| M3 | 〰️ Lissajous | Draws a configurable Lissajous curve |

Additional features:

- exclusive mode selection by default
- sub-pixel remainder tracking for smoother rounded movement
- configurable speed, size, timing, and shape parameters
- debug logging in the Logitech G HUB scripting console

---

## 🎮 Controls

### M2 layer

| Shortcut | Action |
|---|---|
| **M2 + G1** | Toggle Recoil |
| **M2 + G2** | Toggle Center |
| **M2 + G3** | Toggle Spiral |
| **M2 + G4** | Toggle Infinity |
| **M2 + G5** | Toggle Circle |

### M3 layer

| Shortcut | Action |
|---|---|
| **M3 + G1** | Toggle Ellipse |
| **M3 + G2** | Toggle Diamond |
| **M3 + G3** | Toggle Heart |
| **M3 + G4** | Toggle Lissajous |
| **M3 + G5** | Not assigned |

### Run a mode

Hold the **left mouse button** while the mode's M-key layer is active:

- M2 runs Recoil, Center, Spiral, Infinity, or Circle
- M3 runs Ellipse, Diamond, Heart, or Lissajous

With `ExclusiveModes = true`, enabling one mode disables every other mode, including modes on the other layer. Press the same shortcut again to turn the selected mode off.

---

## 📦 Requirements

- Windows
- Logitech G HUB
- a supported Logitech device with:
  - Lua scripting support
  - G-keys
  - M-key switching

---

## 🚀 Installation

1. Open **Logitech G HUB**.
2. Select the profile you want to use.
3. Open the **Scripting / Lua** editor.
4. Paste the contents of `script.lua` into the editor.
5. Save the script and activate the profile.
6. Switch to M2 or M3 and use the controls above to select a mode.
7. Hold the left mouse button on the corresponding layer to run it.

When the profile is activated, the script enables primary mouse-button events, seeds the random-number generator, clears the log, and reports the loaded version.

---

## ⚙️ Configuration

The configurable values are located near the top of `script.lua`.

### General

```lua
local Debug = 1
local ExclusiveModes = true
```

- `Debug`: set to `1` to enable announcements and status output; use `0` to disable it
- `ExclusiveModes`: when `true`, only one of the nine modes can be enabled at a time

### 🎯 Recoil

```lua
local RecoilEnabled = 0
local RecoilDown = 4
local RecoilMaxShots = 150
local RecoilSleepDown = 6
local RecoilSleepRecover = 8

local RecoilBaseOffset = 3
local RecoilRandomMin = 5
local RecoilRandomMax = 16
local RecoilSmoothness = 0.65
local RecoilHorizontalBias = 0
```

- `RecoilDown`: downward movement applied during each recoil step
- `RecoilMaxShots`: maximum number of downward recoil steps per hold
- `RecoilSleepDown` / `RecoilSleepRecover`: delays between jitter phases in milliseconds
- `RecoilRandomMin`: minimum vertical jitter target
- `RecoilRandomMax`: maximum vertical jitter target and horizontal jitter amplitude
- `RecoilSmoothness`: interpolation strength from `0.0` (wild) to `1.0` (very smooth)
- `RecoilHorizontalBias`: shifts the horizontal jitter left or right
- `RecoilBaseOffset`: reserved configuration value; it is not used by the current implementation

The smoothed jitter continues until the left mouse button is released, even after `RecoilMaxShots` has been reached.

### 📍 Center

```lua
local CenterEnabled = 0
local CenterSleep = 2
```

- `CenterSleep`: delay in milliseconds between center operations

### 🌀 Spiral

```lua
local SpiralEnabled = 0
local SpiralStartRadius = 12
local SpiralMaxRadius = 111
local SpiralAngleStep = 0.22
local SpiralRadiusStep = 1.4
local SpiralSleep = 4
local SpiralReturnToCenter = 0
```

- `SpiralStartRadius`: minimum radius
- `SpiralMaxRadius`: maximum radius
- `SpiralAngleStep`: angular change per movement step
- `SpiralRadiusStep`: expansion and contraction per movement step
- `SpiralSleep`: delay between steps in milliseconds
- `SpiralReturnToCenter`: reserved configuration value; it is not used by the current implementation

### ♾️ Infinity

```lua
local InfinityEnabled = 0
local InfinitySize = 100
local InfinityStep = 0.75
local InfinitySleep = 25
```

- `InfinitySize`: overall size of the figure-eight
- `InfinityStep`: parameter change per movement step
- `InfinitySleep`: delay between steps in milliseconds

### ⭕ Circle

```lua
local CircleEnabled = 0
local CircleRadius = 50
local CircleSpeed = 0.85
local CircleSleep = 10
```

- `CircleRadius`: circle radius
- `CircleSpeed`: angular change per movement step
- `CircleSleep`: delay between steps in milliseconds

### 🥚 Ellipse

```lua
local EllipseEnabled = 0
local EllipseRadiusX = 90
local EllipseRadiusY = 45
local EllipseStep = 0.18
local EllipseSleep = 3
```

- `EllipseRadiusX` / `EllipseRadiusY`: horizontal and vertical radii
- `EllipseStep`: parameter change per movement step
- `EllipseSleep`: delay between steps in milliseconds

### 💎 Diamond

```lua
local DiamondEnabled = 0
local DiamondSize = 175
local DiamondStep = 0.14
local DiamondSleep = 6
```

- `DiamondSize`: overall size of the diamond
- `DiamondStep`: parameter change per movement step
- `DiamondSleep`: delay between steps in milliseconds

### ❤️ Heart

```lua
local HeartEnabled = 0
local HeartScale = 25
local HeartStep = 0.13
local HeartSleep = 7
```

- `HeartScale`: scale applied to the heart curve
- `HeartStep`: parameter change per movement step
- `HeartSleep`: delay between steps in milliseconds

### 〰️ Lissajous

```lua
local LissajousEnabled = 0
local LissajousRadiusX = 90
local LissajousRadiusY = 125
local LissajousFrequencyX = 3
local LissajousFrequencyY = 2
local LissajousPhase = math.pi / 2
local LissajousStep = 0.12
local LissajousSleep = 6
```

- `LissajousRadiusX` / `LissajousRadiusY`: horizontal and vertical amplitudes
- `LissajousFrequencyX` / `LissajousFrequencyY`: frequency ratio that determines the curve
- `LissajousPhase`: horizontal phase offset in radians
- `LissajousStep`: parameter change per movement step
- `LissajousSleep`: delay between steps in milliseconds

---

## 🧠 Script Structure

### Helper functions

- `Clamp(v, minV, maxV)`
- `Toggle(v)`
- `BoolText(v)`
- `DisableAllModes()`
- `RoundSigned(v)`
- `GetActiveModeName()`
- `SafeRandom(minV, maxV)`
- `RandomFloat(minV, maxV)`
- `Lerp(a, b, t)`
- `Announce(text)`
- `LogStatus(event, arg)`
- `ResetRecoilJitter()`
- `GetSmoothJitter()`
- `RunParametricMouse(step, sleepMs, pointFunction)`

`RunParametricMouse` provides the shared movement loop used by Ellipse, Diamond, Heart, and Lissajous.

### Motion functions

- `DoRecoil()`
- `ForceCenterMouse()`
- `SpiralMouse()`
- `InfinityMouse()`
- `CircleMouse()`
- `EllipseMouse()`
- `DiamondMouse()`
- `HeartMouse()`
- `LissajousMouse()`

### Toggle functions

- `ToggleRecoil()`
- `ToggleCenter()`
- `ToggleSpiral()`
- `ToggleInfinity()`
- `ToggleCircle()`
- `ToggleEllipse()`
- `ToggleDiamond()`
- `ToggleHeart()`
- `ToggleLissajous()`

---

## 🧾 Debug Logging

When `Debug = 1`, the G HUB scripting console displays a formatted status box containing:

- script name and version
- current event and argument
- active M-key layer
- active mode
- state of all nine modes
- current cursor position

The log is refreshed after handled events. Status-box output is skipped while M1 is active.

---

## 🛠️ Troubleshooting

### The script does not react

- verify that Lua scripting is enabled in G HUB
- verify that the correct profile is active
- use M2 for the five M2 modes and M3 for the four M3 modes
- confirm that the device supports G-keys and M-key switching
- check the G HUB script log for the loaded version and event details

### A mode is enabled but does not run

The selected M-key layer must still be active when you press and hold the left mouse button. For example, Ellipse is toggled and executed on M3, while Circle is toggled and executed on M2.

### Movement is too fast, slow, large, or small

- increase a mode's `Sleep` value to slow down its updates
- decrease `Sleep` to update more quickly
- adjust `Step`, `Speed`, `Radius`, `Size`, or `Scale` to tune the pattern

### Recoil feels too weak or too strong

Adjust `RecoilDown`, the random range, smoothing, timing, or horizontal bias. DPI, polling rate, Windows sensitivity, and application sensitivity also affect the result.

### Motion looks jittery or drifts

- reduce the relevant step or size values
- increase the mode's sleep value slightly
- test with a different DPI or pointer-sensitivity setting

---

## ⚠️ Notes

- All pattern modes use relative movement and begin around the cursor's current position.
- Center uses `MoveMouseTo(32767, 32767)`, the midpoint of G HUB's absolute `0`–`65535` coordinate range.
- Mode output varies with DPI, polling rate, Windows pointer settings, and the active application's sensitivity.
- The script stops the current movement loop when the left mouse button is released.
- `Clamp`, `Toggle`, `SafeRandom`, `RecoilBaseOffset`, and `SpiralReturnToCenter` are present but not used by the current runtime path.

---

## 📁 Suggested Repository Structure

```text
Mouse-FX-Pro/
├─ README.md
└─ script.lua
```

---

## ⚠️ Disclaimer

This project is provided for learning, testing, and automation experiments in Logitech G HUB.

Use it at your own risk and follow the terms, rules, and policies of the software, platforms, and games where you use it.

---

## 📌 Version

**Mouse FX Pro+ v1.4**

---

## ⭐ Support

If you find the project useful, consider giving the repository a star.
