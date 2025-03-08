//
//  CustomerCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 3/8/25.
//

import UIKit
import Swinject
import OSLog

protocol CustomerCoordinatorDelegate: AnyObject {
    func switchToPhotographer(customerCoordinator: CustomerCoordinator)
    func loggedOut(customerCoordinator: CustomerCoordinator)
}

final class CustomerCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var delegate: CustomerCoordinatorDelegate?
    private let navigationController: UINavigationController
    private let container: Container
    private var log = Logger.of("CustomerCoordinator")
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let rootViewController = container.resolve(CustomerViewController.self)
        if let rootViewController = rootViewController {
            rootViewController.delegate = self
            navigationController.viewControllers = [rootViewController]
        }
    }
}

extension CustomerCoordinator: CustomerViewControllerDelegate {
    func switchToPhotographer() {
        delegate?.switchToPhotographer(customerCoordinator: self)
    }
    
    func logOut() {
        delegate?.loggedOut(customerCoordinator: self)
    }
}
