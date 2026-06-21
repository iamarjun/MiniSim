import AppKit
import Foundation

enum MenuImage: String, CaseIterable {
  case box

  var image: NSImage? {
    guard let itemImage = NSImage(named: self.rawValue) else {
      return nil
    }
    itemImage.size = size
    itemImage.isTemplate = true
    return itemImage
  }

  var size: NSSize {
    return NSSize(width: 16.5, height: 15)
  }
}
