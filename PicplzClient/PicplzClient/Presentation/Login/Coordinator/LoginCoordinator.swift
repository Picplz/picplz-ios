//
//  LoginCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit
import OSLog

protocol LoginCoordinatorDelegate: AnyObject {
    func finished(loginCoordinator: LoginCoordinator)
}

final class LoginCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    weak var delegate: LoginCoordinatorDelegate?
    private let navigationController: UINavigationController
    private var log = Logger.of("LoginCoordinator")
    private let container = DIContainerProvider.shared.container
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        log.debug("LoginCoordinator deinit")
    }
    
    func start() {
        var viewModel = container.resolve(OnboardingViewModelProtocol.self)
        viewModel?.delegate = self
        let viewController = OnboardingViewController()
        viewController.viewModel = viewModel
        
        navigationController.viewControllers = [viewController]
        
        log.debug("LoginCoordinator started")
    }
}

extension LoginCoordinator: OnboardingViewModelDelegate {
    func goToLogin(authProvider: AuthProvider) {
        log.debug("LoginCoordinator goToLogin called")
        
        var viewModel = container.resolve(LoginViewModelProtocol.self)
        viewModel?.delegate = self
        let viewController = LoginViewController()
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension LoginCoordinator: LoginViewModelDelegate {
    func loggedIn() {
        log.debug("LoginCoordinator loggedIn called")
        delegate?.finished(loginCoordinator: self)
    }
}
