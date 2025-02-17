//
//  LoginCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit
import OSLog
import Swinject

protocol LoginCoordinatorDelegate: AnyObject {
    func finished(loginCoordinator: LoginCoordinator)
}

final class LoginCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    weak var delegate: LoginCoordinatorDelegate?
    private let navigationController: UINavigationController
    private let container: Container
    private var log = Logger.of("LoginCoordinator")
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    deinit {
        log.debug("LoginCoordinator deinit")
    }
    
    func start() {
        guard let rootViewController = container.resolve(OnboardingViewController.self) else {
            preconditionFailure("viewController could not be resolved...")
        }
        rootViewController.viewModel.delegate = self
        navigationController.viewControllers = [rootViewController]
        
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
//        delegate?.finished(loginCoordinator: self)
        goToSignUp() // FIXME: temporary
    }
    
    private func goToSignUp() {
        let viewController = container.resolve(SignUpViewController.self)!
        navigationController.pushViewController(viewController, animated: true)
    }
}
