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
        
        // MARK: Data
        container.register(AuthManaging.self) { _ in
            AuthManager(keychainStore: KeychainStore(), userDefaultHelper: UserDefaultsHelper())
        }
        .inObjectScope(.container)
        
        // MARK: Domain
        container.register(LoginUseCase.self) { r in
            let authManaging = r.resolve(AuthManaging.self)!
            return LoginUseCaseImpl(authManaging: authManaging)
        }
        container.register(LogoutUseCase.self) { r in
            let authManaging = r.resolve(AuthManaging.self)!
            return LogoutUseCaseImpl(authManaging: authManaging)
        }
        container.register(GetAuthInfoUseCase.self) { r in
            let authManaging = r.resolve(AuthManaging.self)!
            return GetAuthInfoUseCaseImpl(authManaging: authManaging)
        }
        
        // MARK: Presentaion
        // MARK:              ...  View Models
        container.register(MainViewModelProtocol.self) { r in
            let viewModel = MainViewModel()
            viewModel.logoutUseCase = r.resolve(LogoutUseCase.self)
            viewModel.getAuthInfoUseCase = r.resolve(GetAuthInfoUseCase.self)
            return viewModel
        }
        container.register(LoginViewModelProtocol.self) { r in
            let viewModel = LoginViewModel()
            viewModel.loginUseCase = r.resolve(LoginUseCase.self)!
            return viewModel
        }
        container.register(OnboardingViewModelProtocol.self) { _ in OnboardingViewModel() }
        container.register(SignUpViewModelProtocol.self) { _ in SignUpViewModel() }
        
        // MARK:              ...  View Controllers
        container.register(OnboardingViewController.self) { r in
            let vc = OnboardingViewController()
            vc.viewModel = r.resolve(OnboardingViewModelProtocol.self)
            return vc
        }
        container.register(MainViewController.self) { r in
            let vc = MainViewController()
            vc.viewModel = r.resolve(MainViewModelProtocol.self)
            return vc
        }
        container.register(SignUpViewController.self) { r in
            let vc = SignUpViewController()
            vc.viewModel = r.resolve(SignUpViewModelProtocol.self)
            return vc
        }
        
        
        return container
    }
}
