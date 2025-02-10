//
//  DIContainerProvider.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Swinject
import os

final class DIContainerProvider {
    static let shared = DIContainerProvider()
    
    let container: Container
    
    private init() {
        self.container = DIContainerProvider.makeContainer()
        let logger = Logger.of("DIContainerProvider")
        logger.debug("DIContainerProvider init completed")
    }
    
    private static func makeContainer() -> Container {
        let container = Container()
        
        container.register(MainViewModelProtocol.self) { _ in MainViewModel() }
        
        container.register(LoginViewModelProtocol.self) { _ in LoginViewModel() }
        
        container.register(OnboardingViewModelProtocol.self) { _ in OnboardingViewModel() }
        
        return container
    }
}
