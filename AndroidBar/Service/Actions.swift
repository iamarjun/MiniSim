import AppKit
import Foundation

protocol Action {
  func execute() throws
  func showQuestionDialog() -> Bool
}

extension Action {
  func showQuestionDialog() -> Bool {
    false
  }
}

// MARK: General Actions

class CopyIDAction: Action {
  let device: Device

  init(device: Device) {
    self.device = device
  }

  func execute() throws {
    if let deviceId = device.identifier {
      NSPasteboard.general.copyToPasteboard(text: deviceId)
      AndroidBar.showSuccessMessage(title: "Device ID copied to clipboard!", message: deviceId)
    }
  }
}

class CopyNameAction: Action {
  let device: Device

  init(device: Device) {
    self.device = device
  }

  func execute() throws {
    NSPasteboard.general.copyToPasteboard(text: device.name)
    AndroidBar.showSuccessMessage(title: "Device name copied to clipboard!", message: device.name)
  }
}

class DeleteAction: Action {
  let device: Device
  let skipConfirmation: Bool

  init(device: Device, skipConfirmation: Bool = false) {
    self.device = device
    self.skipConfirmation = skipConfirmation
  }

  func showQuestionDialog() -> Bool {
    guard !skipConfirmation else { return false }
    return !NSAlert.showQuestionDialog(
      title: "Are you sure?",
      message: "Are you sure you want to delete this device?"
    )
  }

  func execute() throws {
    try self.device.delete()
    AndroidBar.showSuccessMessage(title: "Device deleted!", message: self.device.name)
    NotificationCenter.default.post(name: .deviceDeleted, object: nil)
  }
}

class CustomCommandAction: Action {
  let device: Device
  let itemName: String

  init(device: Device, itemName: String) {
    self.device = device
    self.itemName = itemName
  }

  func execute() throws {
    if let command = CustomCommandService.getCustomCommand(platform: device.platform, commandName: itemName) {
      try CustomCommandService.runCustomCommand(device, command: command)
    }
  }
}

// MARK: Android Actions

class PasteClipboardAction: Action {
  let device: Device

  init(device: Device) {
    self.device = device
  }

  func execute() throws {
    guard let clipboard = NSPasteboard.general.pasteboardItems?.first,
          let text = clipboard.string(forType: .string) else {
      return
    }
    try ADB.sendText(device: device, text: text)
  }
}

class UploadToDownloadsAction: Action {
  let device: Device
  let destinationLabel = "Downloads"


    init(device: Device) {
    self.device = device
  }

  func execute() throws {
    guard let destinationPath = try resolveDestinationPath() else {
      NSSound.beep()
      NSAlert.showError(
        message: NSLocalizedString(
            "Downloads folder not found on device. Expected \(AndroidUploadPathBuilder.primaryDestinationPath) or \(AndroidUploadPathBuilder.fallbackDestinationPath).",
          comment: ""
        )
      )
      return
    }

    let selectedUrls = UploadHelpers.pickUploadItems(
      prompt: "Upload",
      message: "Choose files or folders to upload to \(destinationLabel)."
    )

    let result = try UploadHelpers.processUploadItems(
      selectedUrls: selectedUrls,
      destinationLabel: destinationLabel,
      missingItemHandler: UploadHelpers.promptForMissingItem
    ) { file in
      let destinationFilePath = AndroidUploadPathBuilder.destinationFilePath(
        for: file,
        destinationPath: destinationPath
      )
      try ADB.push(device: device, sourcePath: file.sourceURL.path, destinationPath: destinationFilePath)
    }

    if result.canceled || result.uploadedCount == 0 {
      return
    }
      
    // Best-effort folder content refresh for Files/MediaStore views (Files app) on Android 11+.
    // (use deprecated MediaScanner broadcast to force path reindexing)
    // See https://stackoverflow.com/questions/66929450/images-not-shown-in-photos-using-adb-push-pictures-to-android-11-emulator
    // and https://stackoverflow.com/questions/64552886/adb-push-files-are-not-showing-on-android-11-emulator
    _ = try? ADB.broadcastMediaScan(device: device, path: destinationPath)

    let uploadedLabel: String
    if result.uploadedCount == 1, let itemName = result.singleUploadedItemName {
      uploadedLabel = itemName
    } else {
      uploadedLabel = "\(result.uploadedCount) items"
    }

    AndroidBar.showSuccessMessage(
      title: "Upload complete",
      message: "Uploaded \(uploadedLabel) to \(destinationPath)."
    )
  }

  private func resolveDestinationPath() throws -> String? {
    if try ADB.directoryExists(device: device, path: AndroidUploadPathBuilder.primaryDestinationPath) {
        return AndroidUploadPathBuilder.primaryDestinationPath
    }
    if try ADB.directoryExists(device: device, path: AndroidUploadPathBuilder.fallbackDestinationPath) {
        return AndroidUploadPathBuilder.fallbackDestinationPath
    }
    return nil
  }
}


class LaunchLogCat: Action {
  let device: Device

  init(device: Device) {
    self.device = device
  }

  func execute() throws {
    try ADB.launchLogCat(device: device)
  }
}

class ColdBootCommand: Action {
  let device: Device

  init(device: Device) {
    self.device = device
  }

  func execute() throws {
    try device.launch(additionalArgs: ["-no-snapshot"])
  }
}

class NoAudioCommand: Action {
  let device: Device

  init(device: Device) {
    self.device = device
  }

  func execute() throws {
    try device.launch(additionalArgs: ["-no-audio"])
  }
}

class ToggleA11yCommand: Action {
  let device: Device

  init(device: Device) {
    self.device = device
  }

  func execute() throws {
    guard let deviceId = device.identifier else {
      return
    }
    ADB.toggleAccesibility(deviceId: deviceId)
  }
}

