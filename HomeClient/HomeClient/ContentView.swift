//  Created by Alexander Skorulis on 14/6/2024.

import SwiftUI

struct ContentView: View {
    
    let service = BonjourService()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
