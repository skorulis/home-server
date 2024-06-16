//  Created by Alexander Skorulis on 14/6/2024.

import SwiftUI

@main
struct HomeClientApp: App {
    
    private let ioc = IOC(purpose: .normal)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
