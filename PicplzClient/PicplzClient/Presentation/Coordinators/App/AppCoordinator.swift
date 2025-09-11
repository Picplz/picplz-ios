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
        initNavigationController()

        if !authManaging.isLogin {
            showLogin()
        } else {
            showMain()
        }

        log.debug("AppCoordinator started")
    }

    func showLogin() {
        if navigationController == nil {
            initNavigationController()
        }

        let coordinator = LoginCoordinator(navigationController: navigationController!, container: container)
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }

    func showMain() {
        if navigationController == nil {
            initNavigationController()
        }

        let coordinator = MainCoordinator(navigationController: navigationController!, container: container)
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
            navigationController = nil
        }

        let customerCoordinator = CustomerTabBarCoordinator(container: container)
        childCoordinators = [customerCoordinator]
        customerCoordinator.start()
        customerCoordinator.delegate = self
        window.rootViewController = customerCoordinator.tabBarController
        window.makeKeyAndVisible()
    }

    func switchToPhotographer() {
        defer {
            navigationController = nil
        }

        let photographerCoordinator = PhotographerTabBarCoordinator()
        childCoordinators = [photographerCoordinator]
        photographerCoordinator.start()
        photographerCoordinator.delegate = self
        window.rootViewController = photographerCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: CustomerTabBarCoordinatorDelegate {
    func switchToPhotographer(customerCoordinator: CustomerTabBarCoordinator) {
        switchToAnother(customerCoordinator)
    }

    func loggedOut(customerCoordinator: CustomerTabBarCoordinator) {
        loggedOut(customerCoordinator)
    }
}

extension AppCoordinator: PhotographerTabBarCoordinatorDelegate {
    func switchToCustomer(photographerCoordinator: PhotographerTabBarCoordinator) {
        switchToAnother(photographerCoordinator)
    }

    func loggedOut(photographerCoordinator: PhotographerTabBarCoordinator) {
        loggedOut(photographerCoordinator)
    }
}

// MARK: - Other Logics
extension AppCoordinator {
    func initNavigationController() {
        navigationController = UIPicplzNavigationController()
        childCoordinators = []
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func loggedOut(_ childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
        showLogin()
    }

    func switchToAnother(_ childCoordinator: Coordinator) {
        guard let childCoordinator = childCoordinators.first else {
            log.warning("childCoordinators is empty")
            return
        }

        if childCoordinator is CustomerTabBarCoordinator {
            switchToPhotographer()
            return
        }

        if childCoordinator is PhotographerTabBarCoordinator {
            switchToCustomer()
            return
        }

        log.warning("unexpected child coordinator: \(String(describing: childCoordinator.self))")
    }
}
