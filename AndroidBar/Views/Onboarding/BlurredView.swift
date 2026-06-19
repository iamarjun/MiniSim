//
//  BlurredView.swift
//  AndroidBar
//
//  Created by Oskar Kwaśniewski on 16/03/2023.
//

import SwiftUI

struct BlurredView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .sidebar
        view.blendingMode = .behindWindow
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) { }
}
