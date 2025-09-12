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
    private let resolver: Resolver
    private var log = Logger.of("LoginCoordinator")

    private var shouldSignUp = true // FIXME: Temporary

    init(navigationController: UINavigationController, resolver: Resolver) {
        self.navigationController = navigationController
        self.resolver = resolver
    }

    deinit {
        log.debug("LoginCoordinator deinit")
    }

    func start() {
        guard let rootViewController = resolver.resolve(OnboardingViewController.self) else {
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
        delegate?.finished(loginCoordinator: self)
    }

    func showSignUp() {
        let coordinator = SignUpCoordinator(navigationController: navigationController, resolver: resolver)
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
