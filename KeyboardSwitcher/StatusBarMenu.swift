//
//  StatusBarMenu.swift
//  KeyboardSwitcher
//
//  Created by Aleksandr on 14/06/2024.
//

import SwiftUI

struct StatusBarMenu: View {
    var body: some View {
        VStack {
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .padding()
        }
    }
}

struct StatusBarMenu_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarMenu()
    }
}
