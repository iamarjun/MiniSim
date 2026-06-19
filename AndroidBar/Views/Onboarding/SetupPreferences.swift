//
//  SetupPreferences.swift
//  AndroidBar
//
//  Created by Oskar Kwaśniewski on 09/10/2023.
//

import SwiftUI

struct SetupPreferences: View {
    var goToNextPage: () -> Void
    @AppStorage(UserDefaults.Keys.enableAndroidEmulators, store: .standard) var enableAndroidEmulators = true

    var body: some View {
        VStack {
            Spacer()
            OnboardingHeader(
                title: "Tooling ⚙️",
                subTitle: "Enable or disable Android emulators here."
            )
            Spacer()
            VStack {
                SetupItemView(imageName: "android_studio", title: "Android Studio", subTitle: "Android Emulators") {
                    Toggle("", isOn: $enableAndroidEmulators)
                        .labelsHidden()
                        .toggleStyle(.switch)
                }
            }
            Spacer()
            if enableAndroidEmulators {
                OnboardingButton("Continue", action: goToNextPage)
            }
            Spacer()
        }
    }
}
