import Foundation

enum DeviceConstants {
  static let deviceBootedError = "Unable to boot device in current state: Booted"

  enum BundleURL: String {
    case emulator = "qemu-system-aarch64"
  }
}
