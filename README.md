# 🖱️ Mouse FX Pro+

<p align="center">
  <img alt="Lua" src="https://img.shields.io/badge/Lua-G%20HUB%20Script-2C2D72?style=for-the-badge&logo=lua&logoColor=white">
  <img alt="Platform" src="https://img.shields.io/badge/Platform-Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white">
  <img alt="Logitech G HUB" src="https://img.shields.io/badge/Logitech-G%20HUB-00B8FC?style=for-the-badge">
  <img alt="Version" src="https://img.shields.io/badge/Version-1.1-red?style=for-the-badge">
</p>

<p align="center">
  <b>Mouse FX Pro+</b> is a Logitech G HUB Lua script with multiple mouse movement modes such as <b>Recoil</b>, <b>Center</b>, <b>Spiral</b>, <b>Infinity</b>, and <b>Circle</b>.<br>
  Modes are toggled via <b>M-Key 3 + G-keys</b> and executed while holding the <b>left mouse button</b>.
</p>

---

## 📌 Overview

Mouse FX Pro+ is designed for Logitech G HUB profiles that support Lua scripting, G-keys, and M-key layers.  
It provides multiple mouse behaviors inside a single script and includes a built-in debug log to show the active mode, recent events, and current cursor position.

This repository is ideal for:
- experimenting with Lua in Logitech G HUB
- testing motion patterns and cursor automation
- learning how to build modular multi-mode G HUB scripts

---

## ✨ Features

| Feature | Description |
|---|---|
| 🎯 Recoil | Controlled downward mouse movement with smoothed random jitter |
| 📍 Center | Forces the cursor to the screen center while the button is held |
| 🌀 Spiral | Moves the cursor in a spiral that expands and contracts while continuing forward |
| ♾️ Infinity | Draws a horizontal figure-eight / infinity shape |
| ⭕ Circle | Moves the cursor in a circular path |
| 🔒 Exclusive Modes | Only one mode can be active at a time |
| 🧾 Debug Logging | Shows event, active mode, toggle states, and cursor position in G HUB |

---

## 🎮 Controls

The script only reacts while **M-Key 3** is active.

### Toggle modes
- **M3 + G1** → Recoil toggle
- **M3 + G2** → Center toggle
- **M3 + G3** → Spiral toggle
- **M3 + G4** → Infinity toggle
- **M3 + G5** → Circle toggle

### Execute active mode
- **Hold Left Click** → runs the currently active mode

---

## 🖼️ Banner / Preview / Screenshots

This README already contains the sections you would usually need for GitHub.  
If you later add assets, place them in a folder such as `assets/` and uncomment or replace the examples below.

### Screenshots

```md
<img width="1427" height="1165" alt="screenshot-1" src="https://github.com/user-attachments/assets/6ad6598d-9704-4b00-9a15-6935e652a844" />
<img width="1428" height="1167" alt="screenshot-2" src="https://github.com/user-attachments/assets/e7c70c9b-80ab-49dd-a6fe-b1a310d8437b" />
```

> Tip: If you do not have images yet, leave these lines removed until you upload your assets.

---

## 📦 Requirements

- **Windows**
- **Logitech G HUB**
- A supported Logitech device with:
  - **Lua scripting**
  - **G-keys**
  - **M-key switching**

---

## 🚀 Installation

1. Open **Logitech G HUB**
2. Select the profile you want to use
3. Open the **Scripting / Lua** editor
4. Paste the script into the editor
5. Save the script
6. Switch to **M-Key 3**
7. Use **G1–G5** to toggle a mode

---

## ⚙️ Configuration

All important values can be adjusted at the top of the script.

### General

```lua
local Debug = 1
local ExclusiveModes = true
```

- `Debug = 1` enables G HUB log output
- `ExclusiveModes = true` ensures only one mode is active at a time

---

## 🎯 Recoil Settings

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

### Description
- `RecoilDown` → base downward movement per cycle
- `RecoilMaxShots` → max number of recoil steps
- `RecoilSleepDown` / `RecoilSleepRecover` → timing between recoil phases
- `RecoilRandomMin` / `RecoilRandomMax` → range of random jitter
- `RecoilSmoothness` → how smooth the jitter transitions are
- `RecoilHorizontalBias` → shifts jitter left or right

---

## 📍 Center Settings

```lua
local CenterEnabled = 0
local CenterSleep = 2
```

### Description
- `CenterSleep` → delay between center-lock operations

---

## 🌀 Spiral Settings

```lua
local SpiralEnabled = 0
local SpiralStartRadius = 12
local SpiralMaxRadius = 111
local SpiralAngleStep = 0.22
local SpiralRadiusStep = 1.4
local SpiralSleep = 4
local SpiralReturnToCenter = 0
```

### Description
- `SpiralStartRadius` → starting radius of the spiral
- `SpiralMaxRadius` → maximum spiral radius
- `SpiralAngleStep` → rotation speed
- `SpiralRadiusStep` → how fast the spiral expands / contracts
- `SpiralSleep` → delay between spiral steps
- `SpiralReturnToCenter` → currently defined in config, but not used by the current implementation

---

## ♾️ Infinity Settings

```lua
local InfinityEnabled = 0
local InfinitySize = 100
local InfinityStep = 0.75
local InfinitySleep = 25
```

### Description
- `InfinitySize` → size of the infinity loop
- `InfinityStep` → parameter step speed
- `InfinitySleep` → delay between each movement step

---

## ⭕ Circle Settings

```lua
local CircleEnabled = 0
local CircleRadius = 50
local CircleSpeed = 0.85
local CircleSleep = 10
```

### Description
- `CircleRadius` → circle size
- `CircleSpeed` → angular speed
- `CircleSleep` → delay between circle steps

---

## 🧠 Included Functions

### Helper Functions
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

### Motion Functions
- `CircleMouse()`
- `SpiralMouse()`
- `InfinityMouse()`
- `DoRecoil()`
- `ForceCenterMouse()`

### Toggle Functions
- `ToggleCircle()`
- `ToggleRecoil()`
- `ToggleCenter()`
- `ToggleSpiral()`
- `ToggleInfinity()`

---

## 🧾 Debug Logging

When `Debug = 1`, the script writes a formatted status box to the G HUB log.

It includes:
- current event
- current argument
- active M-key
- active mode
- state of all modes
- cursor position

This is useful for tuning timing, troubleshooting input, and confirming whether the correct mode is active.

---

## 🛠️ Troubleshooting

### Script does not react
- make sure **Lua scripting** is enabled in G HUB
- make sure the correct **profile** is selected
- make sure **M-Key 3** is active
- confirm your device supports **G-keys / M-key switching**

### Movement is too fast or too slow
- adjust the `Sleep` values
- reduce or increase `Step`, `Speed`, or `RadiusStep`

### Recoil feels too weak or too strong
Adjust these values:
- `RecoilDown`
- `RecoilRandomMin`
- `RecoilRandomMax`
- `RecoilSmoothness`
- `RecoilHorizontalBias`

### Motion looks jittery or drifts
- reduce radius or step values
- increase sleep slightly
- lower movement speed for smoother motion

---

## ⚠️ Notes

- The script is designed around **M-Key 3**
- With `ExclusiveModes = true`, enabling one mode disables the others
- Mouse behavior depends on:
  - DPI
  - polling rate
  - Windows sensitivity
  - in-game sensitivity
- `Center` uses `MoveMouseTo(32767, 32767)`, which corresponds to the virtual absolute center target used by G HUB

---

## 📁 Suggested Repository Structure

```text
Mouse-FX-Pro/
├─ README.md
├─ script.lua
├─ screenshot-1.png
└─ screenshot-2.png
```

---

## ⚠️ Disclaimer

This project is provided for **learning, testing, and automation experiments** inside Logitech G HUB Lua.

Use it at your own risk. Always follow the terms, rules, and policies of the software, platforms, and games you use.

---

## 📌 Version

**Mouse FX Pro+ v1.1**

---

## ⭐ Support

If you like the script, consider giving the repository a **star**.
