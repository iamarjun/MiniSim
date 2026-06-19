//
//  NSMenuItem+ImageInit.swift
//  AndroidBar
//
//  Created by Oskar Kwaśniewski on 26/01/2023.
//

import AppKit

extension NSMenuItem {
    convenience init(
        title: String,
        action: Selector?,
        keyEquivalent: String,
        type: DeviceMenuItem,
        image: NSImage? = nil
    ) {
        self.init(title: title, action: action, keyEquivalent: keyEquivalent)

        self.image = image ?? NSImage(systemSymbolName: "desktopcomputer", accessibilityDescription: title)
        self.tag = type.rawValue
    }
}
