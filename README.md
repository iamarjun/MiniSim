# AndroidBar

![App logo](/AndroidBar/Assets.xcassets/AppIcon.appiconset/256.png)

## About

AndroidBar is a lightweight macOS menu bar app for launching and managing Android emulators.

Written in Swift and AppKit.

## Install

Build from source:

```shell
git clone https://github.com/iamarjun/AndroidBar.git
cd AndroidBar
open AndroidBar.xcodeproj
```

## Features

- Lightweight
- Fast, 100% native
- Open Source
- Open with shortcut: <kbd>⌥ + ⇧ + e</kbd>
- Launch Android emulators (virtual + physical)
  - Cold boot emulators
  - Run without audio (your Bluetooth headphones will thank you 🎧)
  - Toggle accessibility on selected emulator
  - Copy device name
  - Copy device ADB id
  - Upload files to emulator
- Focus devices using accessibility API
- Set default launch flags
- Indicate running devices
- Custom commands

## Usage

> **Important**
> Requires Android Studio and a working `adb` / `emulator` setup on your machine.

Global shortcut to open the menu: <kbd>⌥ + ⇧ + e</kbd>

Check out the docs [here](https://github.com/iamarjun/AndroidBar/tree/main/docs).

## Credits

Forked from [MiniSim](https://github.com/okwasniewski/MiniSim) by [@okwasniewski](https://github.com/okwasniewski). iOS simulator support removed; Android-only.
