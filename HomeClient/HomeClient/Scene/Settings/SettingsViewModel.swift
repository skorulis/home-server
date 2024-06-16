//  Created by Alexander Skorulis on 16/6/2024.

import ASKCore
import Foundation
import Swinject
import SwinjectMacros

final class SettingsViewModel: CoordinatedViewModel, ObservableObject {
    
    private let bonjourService: BonjourService
    
    @Resolvable
    init(bonjourService: BonjourService) {
        self.bonjourService = bonjourService
        super.init()
        bonjourService.objectWillChange
            .sink { [unowned self] _ in
                self.objectWillChange.send()
            }
            .store(in: &subscribers)
    }
}

// MARK: - Computed Values

extension SettingsViewModel {
    
    var serverString: String {
        return bonjourService.serverEndpoint?.url?.absoluteString ?? "Waiting"
    }
}
