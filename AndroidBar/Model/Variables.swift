//
//  Variables.swift
//  MiniSim
//
//  Created by Oskar Kwaśniewski on 02/06/2023.
//

import Foundation

enum Variables: String {
    case deviceName = "$device_name"

    // Android Specific
    case adbId = "$adb_id"
    case androidHomePath = "$android_home_path"
    case adbPath = "$adb_path"

    static var common: [Variables] {
        [deviceName]
    }

    static var android: [Variables] {
        [androidHomePath, adbPath]
    }

    var description: String {
        switch self {
        case .deviceName:
            return NSLocalizedString("Name of the device", comment: "")
        case .adbId:
            return NSLocalizedString("ID of running device for example: emulator-5554", comment: "")
        case .androidHomePath:
            return NSLocalizedString("Path of $ANDROID_HOME", comment: "")
        case .adbPath:
            return NSLocalizedString("Path of adb utility", comment: "")
        }
    }
}
