@testable import MiniSim
import XCTest

class DeviceDiscoveryTests: XCTestCase {
  var androidDiscovery: AndroidDeviceDiscovery!
  var shellStub: ShellStub!

  override func setUp() {
    super.setUp()
    shellStub = ShellStub()
    androidDiscovery = AndroidDeviceDiscovery()
    androidDiscovery.shell = shellStub
  }

  override func tearDown() {
    shellStub.tearDown()
    super.tearDown()
  }

  func testAndroidDeviceDiscoveryCommands() throws {
    shellStub.mockedExecute = { command, arguments, _ in
      if command.hasSuffix("adb") {
        XCTAssertEqual(arguments, ["devices", "-l"])
        return "mock adb output"
      }
      if command.hasSuffix("emulator") {
        XCTAssertEqual(arguments, ["-list-avds"])
        return "mock emulator output"
      }
      XCTFail("Unexpected command: \(command)")
      return ""
    }

    _ = try androidDiscovery.getDevices(type: .physical)
    _ = try androidDiscovery.getDevices(type: .virtual)
    _ = try androidDiscovery.getDevices()

    XCTAssertTrue(shellStub.lastExecutedCommand.contains("adb"))
  }

  func testAndroidCheckSetup() throws {
    shellStub.mockedExecute = { _, _, _ in
      "/path/to/android/sdk"
    }

    XCTAssertNoThrow(try androidDiscovery.checkSetup())
  }
}
