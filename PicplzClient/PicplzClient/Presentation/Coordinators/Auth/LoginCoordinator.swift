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
    
    private var shouldSignUp = true // FIXME: Temporary
    
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
    func loggedIn() {
        log.debug("LoginCoordinator loggedIn called")
        if shouldSignUp {
            showSignUp()
        }
    }
    
    private func showSignUp() {
        let coordinator = SignUpCoordinator(navigationController: navigationController, container: container)
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }
}

extension LoginCoordinator: SignUpCoordinatorDelegate {
    func finished(signUpCoordinator: SignUpCoordinator) {
        log.debug("LoginCoordinator finished(signUpCoordinator:) called")
        
        childCoordinators = childCoordinators.filter { $0 !== signUpCoordinator }
        delegate?.finished(loginCoordinator: self)
    }
}
