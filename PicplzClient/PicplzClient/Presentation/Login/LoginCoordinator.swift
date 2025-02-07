//
//  LoginCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit
import OSLog

protocol LoginCoordinatorDelegate: AnyObject {
    func finished(coordinator: LoginCoordinator)
}

final class LoginCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    weak var delegate: LoginCoordinatorDelegate?
    private let navigationController: UINavigationController
    private var log = Logger.of("LoginCoordinator")
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        log.debug("LoginCoordinator deinit")
    }
    
    func start() {
        let viewController = LoginViewController()
        viewController.delegate = self
        navigationController.viewControllers = [viewController]
        
        log.debug("LoginCoordinator started")
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func loggedIn() {
        log.debug("LoginCoordinator loggedIn called")
        delegate?.finished(coordinator: self)
    }
}
