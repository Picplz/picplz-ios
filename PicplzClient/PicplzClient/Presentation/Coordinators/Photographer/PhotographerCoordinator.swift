//
//  PhotographerCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 3/8/25.
//

import UIKit
import Swinject
import OSLog

protocol PhotographerCoordinatorDelegate: AnyObject {
    func switchToCustomer(photographerCoordinator: PhotographerCoordinator)
    func loggedOut(photographerCoordinator: PhotographerCoordinator)
}

final class PhotographerCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var delegate: PhotographerCoordinatorDelegate?
    private let navigationController: UINavigationController
    private let container: Container
    private var log = Logger.of("PhotographerCoordinator")

    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let rootViewController = container.resolve(PhotographerViewController.self)
        if let rootViewController = rootViewController {
            rootViewController.delegate = self
            navigationController.viewControllers = [rootViewController]
        }
    }
}

extension PhotographerCoordinator: PhotographerViewControllerDelegate {
    func switchToCustomer() {
        delegate?.switchToCustomer(photographerCoordinator: self)
    }

    func logOut() {
        delegate?.loggedOut(photographerCoordinator: self)
    }
}
