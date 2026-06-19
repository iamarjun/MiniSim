import Foundation

protocol DeviceDiscoveryService {
  var shell: ShellProtocol { get set }

  func getDevices(type: DeviceType?) throws -> [Device]
  func getDevices() throws -> [Device]
  func checkSetup() throws -> Bool
}

extension DeviceDiscoveryService {
  func getDevices() throws -> [Device] {
    try getDevices(type: nil)
  }
}

class AndroidDeviceDiscovery: DeviceDiscoveryService {
  var shell: ShellProtocol = Shell()

  func getDevices(type: DeviceType? = nil) throws -> [Device] {
    switch type {
    case .physical:
      return try getAndroidPhysicalDevices()
    case .virtual:
      return try getAndroidEmulators()
    case nil:
      let emulators = try getAndroidEmulators()
      let devices = try getAndroidPhysicalDevices()
      return emulators + devices
    }
  }

  private func getAndroidPhysicalDevices() throws -> [Device] {
    let adbPath = try ADB.getAdbPath()
    let output = try shell.execute(command: adbPath, arguments: ["devices", "-l"])

    return DeviceParserFactory().getParser(.androidPhysical).parse(output)
  }

  private func getAndroidEmulators() throws -> [Device] {
    let emulatorPath = try ADB.getEmulatorPath()
    let output = try shell.execute(command: emulatorPath, arguments: ["-list-avds"])

    return DeviceParserFactory().getParser(.androidEmulator).parse(output)
  }

  func checkSetup() throws -> Bool {
    let emulatorPath = try ADB.getAndroidHome()
    try ADB.checkAndroidHome(path: emulatorPath)
    return true
  }
}
