//
//  MenuIcons.swift
//  AndroidBar
//

import AppKit
import Foundation

enum MenuBarGlyph {
    static func image(hasRunning: Bool) -> NSImage {
        let size = NSSize(width: 16, height: 16)
        let image = NSImage(size: size, flipped: false) { _ in
            // Phone outline — SVG: rect x=4.4 y=1.8 w=7.2 h=12.4 rx=1.7
            // AppKit y-origin is bottom; symmetric rect maps to same coords
            let phoneRect = NSRect(x: 4.4, y: 1.8, width: 7.2, height: 12.4)
            let phonePath = NSBezierPath(roundedRect: phoneRect, xRadius: 1.7, yRadius: 1.7)
            phonePath.lineWidth = 1.3
            NSColor.labelColor.setStroke()
            phonePath.stroke()

            // Center dot — cx=8 cy=8 r=1.6 (center of 16×16, same in both coord systems)
            let r: CGFloat = 1.6
            let dotPath = NSBezierPath(ovalIn: NSRect(x: 8 - r, y: 8 - r, width: r * 2, height: r * 2))
            if hasRunning {
                NSColor(calibratedRed: 55 / 255, green: 214 / 255, blue: 122 / 255, alpha: 1).setFill()
            } else {
                NSColor.labelColor.setFill()
            }
            dotPath.fill()
            return true
        }
        // Template when idle — system tints to match bar; non-template when running so green dot shows
        image.isTemplate = !hasRunning
        return image
    }
}
