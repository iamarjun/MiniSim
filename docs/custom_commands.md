## What are custom commands?

Custom commands let you add additional menu items that speed up your workflow. If you have a command you run regularly in the terminal, you can convert it to a custom command.

Some examples:

- Reverse Android emulator port (for React Native / Metro)
- Launch Logcat
- Execute a sequence of ADB commands to log into your app
- Wipe emulator data

## Creating your first command

1. Go to Preferences > Commands > Add new
2. Assign a name
3. Write a custom command using the available variables (see below)
4. Choose an icon
5. Click Add

## Available variables

| Variable | Description |
|---|---|
| `$adb_path` | Absolute path to the `adb` binary |
| `$adb_id` | ADB device ID of the selected emulator/device |
| `$android_home_path` | Path to `$ANDROID_HOME` |
| `$device_name` | Name of the selected device |

## Ready-to-use recipes

### Reverse React Native Metro port

```sh
$adb_path -s $adb_id reverse tcp:8081 tcp:8081
```

### Launch Logcat

```sh
osascript -e 'tell app "Terminal"
    do script "$adb_path -s $adb_id logcat -v color"
end tell'
```

### Log into your app

```sh
$adb_path -s $adb_id shell input text "login@example.com" \
  && $adb_path -s $adb_id shell input tap 500 600 \
  && $adb_path -s $adb_id shell input text "password"
```

_Adjust tap coordinates to match your app's UI._

### Wipe emulator data

```sh
$android_home_path/emulator/emulator @$device_name -wipe-data
```
