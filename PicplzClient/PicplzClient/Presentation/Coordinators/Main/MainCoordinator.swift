//
//  MainCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit
import OSLog
import Swinject

protocol MainCoordinatorDelegate: AnyObject {
    func finished(mainCoordinator: MainCoordinator)
}

final class MainCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    weak var delegate: MainCoordinatorDelegate?
    private let navigationController: UINavigationController
    private let container: Container
    private var log = Logger.of("MainCoordinator")
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    deinit {
        log.debug("MainCoordinator deinit")
    }
    
    func start() {
        guard let rootViewController = container.resolve(MainViewController.self) else {
            preconditionFailure("viewController could not be resolved...")
        }
        rootViewController.viewModel.delegate = self
        navigationController.viewControllers = [rootViewController]
    }
}

extension MainCoordinator: MainViewModelDelegate {
    func loggedOut() {
        delegate?.finished(mainCoordinator: self)
    }
}
