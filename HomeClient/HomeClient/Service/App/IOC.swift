//  Created by Alexander Skorulis on 15/6/2024.

import ASKCore
import Swinject

public final class IOC: IOCService {
    
    public override init(purpose: IOCPurpose = .testing) {
        super.init(purpose: purpose)
        
        registerServices()
        registerStores()
        registerViewModels()
    }
    
    private func registerStores() {
        
    }
    
    private func registerViewModels() {
        
    }
    
    private func registerServices() {
        container.register(BonjourService.self) { _ in BonjourService() }
    }
    
}

