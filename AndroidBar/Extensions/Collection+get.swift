//
//  Collection+get.swift
//  AndroidBar
//
//  Created by Oskar Kwaśniewski on 04/03/2023.
//

import Foundation

extension Collection {
    /// Get at index object
    ///
    /// - Parameter index: Index of object
    /// - Returns: Element at index or nil
    func get(at index: Index) -> Iterator.Element? {
        self.indices.contains(index) ? self[index] : nil
    }
}
