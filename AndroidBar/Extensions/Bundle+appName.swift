//
//  Bundle+appName.swift
//  AndroidBar
//
//  Created by Oskar Kwaśniewski on 29/01/2023.
//

import Foundation

extension Bundle {
    var appName: String? {
        object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
