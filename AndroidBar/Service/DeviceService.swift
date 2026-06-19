import AppKit
import Foundation
import UserNotifications

protocol DeviceServiceCommon {
  var shell: ShellProtocol { get set }
  var device: Device { get }

  func deleteDevice() throws
  func launchDevice(additionalArgs: [String]) throws
  func focusDevice()
}

extension Device {
  var deviceService: DeviceServiceCommon {
    DeviceServiceFactory.getDeviceService(device: self)
  }

  func delete() throws {
    try deviceService.deleteDevice()
  }

  func focus() {
    deviceService.focusDevice()
  }

  func launch(additionalArgs: [String] = []) throws {
    try deviceService.launchDevice(additionalArgs: additionalArgs)
  }
}

extension DeviceServiceCommon {
  func focusDevice() {
    Thread.assertBackgroundThread()

    let runningApps = NSWorkspace.shared.runningApplications.filter { $0.activationPolicy == .regular }

    for app in runningApps {
      guard
        let bundleURL = app.bundleURL?.absoluteString,
        bundleURL.contains(DeviceConstants.BundleURL.emulator.rawValue) else {
        continue
      }

      for window in AccessibilityElement.allWindowsForPID(app.processIdentifier) {
        guard let windowTitle = window.attribute(key: .title, type: String.self),
              !windowTitle.isEmpty else {
          continue
        }

        if !matchDeviceTitle(windowTitle: windowTitle, device: device) {
          continue
        }

        AccessibilityElement.forceFocus(pid: app.processIdentifier)
      }
    }
  }

  private func matchDeviceTitle(windowTitle: String, device: Device) -> Bool {
    let deviceName = windowTitle.match(#"(?<=- ).*?(?=:)"#).first?.first
    return deviceName == device.name
  }
}
