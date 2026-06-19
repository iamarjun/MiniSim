//
//  MainMenuActions.swift
//  AndroidBar
//
//  Created by Oskar Kwaśniewski on 27/01/2023.
//

import Foundation

enum MainMenuActions: Int, CaseIterable {
    case preferences = 201
    case quit

    var keyEquivalent: String {
        switch self {
        case .quit:
            return "q"
        case .preferences:
            return ","
        }
    }

    var title: String {
        switch self {
        case .quit:
            return NSLocalizedString("Quit", comment: "")
        case .preferences:
            return NSLocalizedString("Preferences", comment: "")
        }
    }
}
