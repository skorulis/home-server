//  Created by Alexander Skorulis on 15/6/2024.

import Foundation
import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel: SettingsViewModel
    
    var body: some View {
        Text("ServerURL: \(viewModel.serverString)")
    }
    
}
