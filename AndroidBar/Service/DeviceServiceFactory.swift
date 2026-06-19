import Foundation

class DeviceServiceFactory {
  private static let queue = DispatchQueue(
    label: "com.AndroidBar.DeviceService",
    qos: .userInteractive,
    attributes: .concurrent
  )

  static func getDeviceService(device: Device) -> DeviceServiceCommon {
    return AndroidDeviceService(device: device)
  }

  static func getDeviceDiscoveryService(platform: Platform) -> DeviceDiscoveryService {
    return AndroidDeviceDiscovery()
  }

  static func getAllDevices(
    android: Bool,
    completionQueue: DispatchQueue = .main,
    completion: @escaping ([Device], Error?) -> Void
  ) {
    queue.async {
      do {
        var devicesArray: [Device] = []

        if android {
          try devicesArray.append(contentsOf: AndroidDeviceDiscovery().getDevices())
        }

        completionQueue.async {
          completion(devicesArray, nil)
        }
      } catch {
        completionQueue.async {
          completion([], error)
        }
      }
    }
  }
}
