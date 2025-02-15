//
//  AppCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit
import OSLog

final class AppCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    private let window: UIWindow
    private let navigationController: UINavigationController
    private var isLoggedIn = false
    private let container: Container
    private let log = Logger.of("AppCoordinator")
    
    init?(window: UIWindow?) {
    init?(window: UIWindow?, container: Container) {
        guard let window = window else { return nil }
        
        self.window = window
        navigationController = UINavigationController()
        
        self.container = container
    }
    
    deinit {
        log.debug("AppCoordinator deinit")
    }
    
    func start() {
        if !isLoggedIn {
            showLogin()
        } else {
            showMain()
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        log.debug("AppCoordinator started")
    }
    
    func showLogin() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }
    
    func showMain() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }
}

extension AppCoordinator: LoginCoordinatorDelegate {
    func finished(loginCoordinator: LoginCoordinator) {
        log.debug("AppCoordinator finished(loginCoordinator:) called")
        
        childCoordinators = childCoordinators.filter { $0 !== loginCoordinator }
        showMain()
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func finished(mainCoordinator: MainCoordinator) {
        log.debug("AppCoordinator finished(mainCoordinator:) called")
        
        childCoordinators = childCoordinators.filter { $0 !== mainCoordinator }
        showLogin()
    }
}
