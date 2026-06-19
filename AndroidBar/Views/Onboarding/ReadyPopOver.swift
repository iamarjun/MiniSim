//
//  ReadyPopOver.swift
//  AndroidBar
//
//  Created by Oskar Kwaśniewski on 28/03/2023.
//

import SwiftUI

struct ReadyPopOver: View {
    var body: some View {
        VStack {
            Text("AndroidBar is ready to use!")
                .fontWeight(.semibold)
        }
        .frame(width: 180, height: 30)
    }
}

struct ReadyPopOver_Previews: PreviewProvider {
    static var previews: some View {
        ReadyPopOver()
    }
}
