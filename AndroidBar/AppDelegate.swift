//
//  AppDelegate.swift
//  AndroidBar
//
//  Created by Oskar Kwaśniewski on 26/01/2023.
//

import Cocoa
import KeyboardShortcuts

class AppDelegate: NSObject, NSApplicationDelegate {
    private var androidBar: AndroidBar!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        androidBar = AndroidBar()

        KeyboardShortcuts.onKeyUp(for: .toggleAndroidBar) {
            self.androidBar.open()
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        true
    }
}
