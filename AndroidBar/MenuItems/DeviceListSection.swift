//
//  DeviceListSection.swift
//  AndroidBar
//
//  Created by Anton Kolchunov on 11.10.23.
//

import Foundation

enum DeviceListSection: Int, CaseIterable {
    case androidPhysical = 102
    case androidVirtual

    var title: String {
        switch self {
        case .androidVirtual:
            return NSLocalizedString("Android Emulators", comment: "")
        case .androidPhysical:
            return NSLocalizedString("Android Devices", comment: "")
        }
    }
}
