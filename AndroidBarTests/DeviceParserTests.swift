@testable import AndroidBar
import XCTest

class DeviceParserTests: XCTestCase {
  class ADB: ADBProtocol {
    static func sendText(device: Device, text: String) throws {}
    static func push(device: Device, sourcePath: String, destinationPath: String) throws {}
    static func broadcastMediaScan(device: Device, path: String) throws {}
    static func directoryExists(device: Device, path: String) throws -> Bool { false }
    static func launchLogCat(device: Device) throws {}
    static var shell: ShellProtocol = Shell()
    static func getAndroidHome() throws -> String { "" }
    static func getAdbId(for deviceName: String) throws -> String {
      if deviceName == "Nexus_5X_API_28" {
        throw NSError(domain: "ADBError", code: 1, userInfo: nil)
      }
      return "mock_adb_id_for_\(deviceName)"
    }
    static func checkAndroidHome(path: String, fileManager: FileManager) throws -> Bool { true }
    static func isAccesibilityOn(deviceId: String) -> Bool { false }
    static func toggleAccesibility(deviceId: String) {}
    static func getEmulatorPath() throws -> String { "" }
    static func getAdbPath() throws -> String { "/mock/adb/path" }
  }

  func testDeviceParserFactory() {
    let androidParser = DeviceParserFactory().getParser(.androidEmulator)
    XCTAssertTrue(androidParser is AndroidEmulatorParser)

    let androidPhysicalParser = DeviceParserFactory().getParser(.androidPhysical)
    XCTAssertTrue(androidPhysicalParser is AndroidPhysicalDeviceParser)
  }

  func testAndroidEmulatorParser() {
    let parser = AndroidEmulatorParser(adb: ADB.self)
    let input = """
        Pixel_3a_API_30_x86
        Pixel_4_API_29
        Nexus_5X_API_28
        """

    let devices = parser.parse(input)

    XCTAssertEqual(devices.count, 3)

    XCTAssertEqual(devices[0].name, "Pixel_3a_API_30_x86")
    XCTAssertEqual(devices[0].identifier, "mock_adb_id_for_Pixel_3a_API_30_x86")
    XCTAssertTrue(devices[0].booted)
    XCTAssertEqual(devices[0].platform, .android)
    XCTAssertEqual(devices[0].type, .virtual)

    XCTAssertEqual(devices[1].name, "Pixel_4_API_29")
    XCTAssertEqual(devices[1].identifier, "mock_adb_id_for_Pixel_4_API_29")
    XCTAssertTrue(devices[1].booted)
    XCTAssertEqual(devices[1].platform, .android)
    XCTAssertEqual(devices[1].type, .virtual)

    XCTAssertEqual(devices[2].name, "Nexus_5X_API_28")
    XCTAssertEqual(devices[2].identifier, nil)
    XCTAssertFalse(devices[2].booted)
    XCTAssertEqual(devices[2].platform, .android)
    XCTAssertEqual(devices[2].type, .virtual)
  }

  func testAndroidPhysicalDeviceParser() {
    let parser = AndroidPhysicalDeviceParser()
    let emptyInput = """
        List of devices attached

        """

    var devices = parser.parse(emptyInput)
    XCTAssertEqual(devices.count, 0)

    let singleEmulatorInput = """
      List of devices attached
      emulator-5554          device product:sdk_gphone64_arm64 model:sdk_gphone64_arm64 device:emu64a transport_id:3

      """

    devices = parser.parse(singleEmulatorInput)
    XCTAssertEqual(devices.count, 0)

    let singlePhysicalDeviceInput = """
      List of devices attached
      RFCWA0FXXXX            device 0-1 product:a34xdxx model:SM_A346E device:a34x transport_id:5

      """

    devices = parser.parse(singlePhysicalDeviceInput)
    XCTAssertEqual(devices.count, 1)

    XCTAssertEqual(devices[0].name, "SM_A346E")
    XCTAssertEqual(devices[0].identifier, "RFCWA0FXXXX")
    XCTAssertTrue(devices[0].booted)
    XCTAssertEqual(devices[0].platform, .android)
    XCTAssertEqual(devices[0].type, .physical)

    let mixedInput = """
      List of devices attached
      emulator-5554          device product:sdk_gphone64_arm64 model:sdk_gphone64_arm64 device:emu64a transport_id:3
      RFCWA0FXXXX            device 0-1 product:a34xdxx model:SM_A346E device:a34x transport_id:5

      """

    devices = parser.parse(mixedInput)
    XCTAssertEqual(devices.count, 1)

    XCTAssertEqual(devices[0].name, "SM_A346E")
    XCTAssertEqual(devices[0].identifier, "RFCWA0FXXXX")
    XCTAssertTrue(devices[0].booted)
    XCTAssertEqual(devices[0].platform, .android)
    XCTAssertEqual(devices[0].type, .physical)
  }

  func filtersOutEmulatorCrashData() {
    let parser = AndroidEmulatorParser(adb: ADB.self)
    let input = """
        Pixel_3a_API_30_x86
        INFO    | Storing crashdata in: /tmp/android-test/emu-crash-34.1.20.db, detection is enabled for process: 58515
        """

    let devices = parser.parse(input)

    XCTAssertEqual(devices.count, 1)
    XCTAssertEqual(devices[0].name, "Pixel_3a_API_30_x86")
    XCTAssertNil(devices.first { $0.name.contains("crashdata") })
  }

  func testAndroidEmulatorParserWithADBFailure() {
    class FailingADB: ADBProtocol {
      static func sendText(device: Device, text: String) throws {}
      static func push(device: Device, sourcePath: String, destinationPath: String) throws {}
      static func broadcastMediaScan(device: Device, path: String) throws {}
      static func directoryExists(device: Device, path: String) throws -> Bool { false }
      static func launchLogCat(device: Device) throws {}
      static func getAndroidHome() throws -> String { "" }
      static var shell: ShellProtocol = Shell()
      static func getAdbId(for deviceName: String) throws -> String {
        throw NSError(domain: "ADBError", code: 2, userInfo: nil)
      }
      static func getAdbPath() throws -> String {
        throw NSError(domain: "ADBError", code: 1, userInfo: nil)
      }
      static func checkAndroidHome(path: String, fileManager: FileManager) throws -> Bool { true }
      static func isAccesibilityOn(deviceId: String) -> Bool { false }
      static func toggleAccesibility(deviceId: String) {}
      static func getEmulatorPath() throws -> String { "" }
    }

    let parser = AndroidEmulatorParser(adb: FailingADB.self)
    let input = "Pixel_3a_API_30_x86"

    let devices = parser.parse(input)

    XCTAssertFalse(devices.isEmpty)
    XCTAssertEqual(devices[0].name, "Pixel_3a_API_30_x86")
    XCTAssertFalse(devices[0].booted)
  }
}
