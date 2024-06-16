//  Created by Alexander Skorulis on 14/6/2024.

import SwiftUI

struct ContentView: View {
    
    @Environment(\.factory) private var factory
    
    var body: some View {
        SettingsView(viewModel: factory.main.resolve())
    }
}

#Preview {
    ContentView()
}
