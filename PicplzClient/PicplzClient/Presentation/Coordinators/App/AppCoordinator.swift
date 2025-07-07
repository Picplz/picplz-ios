//
//  AppCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit
import OSLog
import Swinject

final class AppCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    private let window: UIWindow
    private var navigationController: UINavigationController?
    private let container: Container
    private let authManaging: AuthManaging
    private let log = Logger.of("AppCoordinator")
    
    init?(window: UIWindow?, container: Container) {
        guard let window = window else { return nil }
        
        self.window = window
        navigationController = UIPicplzNavigationController()
        
        self.container = container
        
        if let authManaging = container.resolve(AuthManaging.self) {
            self.authManaging = authManaging
        } else {
            log.error("AuthManaging could not be resolved...")
            preconditionFailure("AuthManaging could not be resolved...")
        }
    }
    
    deinit {
        log.debug("AppCoordinator deinit")
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        if !authManaging.isLogin {
            showLogin()
        } else {
            showMain()
        }
        
        log.debug("AppCoordinator started")
    }
    
    func showLogin() {
        guard let navigationController = navigationController else {
            log.error("navigationController is nil")
            return
        }
        
        let coordinator = LoginCoordinator(navigationController: navigationController, container: container)
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }
    
    func showMain() {
        guard let navigationController = navigationController else {
            log.error("navigationController is nil")
            return
        }
        
        let coordinator = MainCoordinator(navigationController: navigationController, container: container)
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
    
    func switchToCustomer() {
        defer {
            childCoordinators = []
            navigationController = nil
        }
        
        let customerCoordinator = CustomerTabBarCoordinator(container: container)
        customerCoordinator.start()
        window.rootViewController = customerCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
    
    func switchToPhotographer() {
        defer {
            childCoordinators = []
            navigationController = nil
        }
        
        let photographerCoordinator = PhotographerTabBarCoordinator()
        photographerCoordinator.start()
        window.rootViewController = photographerCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
}
