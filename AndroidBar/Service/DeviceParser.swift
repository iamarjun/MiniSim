import Foundation

enum DeviceParserType {
  case androidEmulator
  case androidPhysical
}

protocol DeviceParser {
  func parse(_ input: String) -> [Device]
}

class DeviceParserFactory {
  func getParser(_ type: DeviceParserType) -> DeviceParser {
    switch type {
    case .androidEmulator:
      return AndroidEmulatorParser()
    case .androidPhysical:
      return AndroidPhysicalDeviceParser()
    }
  }
}

class AndroidEmulatorParser: DeviceParser {
  let adb: ADBProtocol.Type

  required init(adb: ADBProtocol.Type = ADB.self) {
    self.adb = adb
  }

  func parse(_ input: String) -> [Device] {
    let deviceNames = input.components(separatedBy: .newlines)
    return deviceNames
      .filter { !$0.isEmpty && !$0.contains("Storing crashdata") }
      .compactMap { deviceName in
        let adbId = try? adb.getAdbId(for: deviceName)
        return Device(name: deviceName, identifier: adbId, booted: adbId != nil, platform: .android, type: .virtual)
      }
  }
}

class AndroidPhysicalDeviceParser: DeviceParser {
  func parse(_ input: String) -> [Device] {
    var splitted = input.components(separatedBy: "\n")
    splitted.removeFirst()
    let filtered = splitted.filter { !$0.contains("emulator") }

    return filtered.compactMap { item -> Device? in
      let serialNoIdx = 0
      let modelNameIdx = 4
      let components = item.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
      guard components.count > 4 else {
        return nil
      }

      let id = components[serialNoIdx]
      let name = components[modelNameIdx].components(separatedBy: ":")[1]

      return Device(
        name: name,
        identifier: id,
        booted: true,
        platform: .android,
        type: .physical
      )
    }
  }
}
