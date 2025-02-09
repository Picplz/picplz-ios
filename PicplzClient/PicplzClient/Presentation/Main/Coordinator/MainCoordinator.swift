//
//  MainCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit
import OSLog

protocol MainCoordinatorDelegate: AnyObject {
    func finished(mainCoordinator: MainCoordinator)
}

final class MainCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    weak var delegate: MainCoordinatorDelegate?
    private let navigationController: UINavigationController
    private var log = Logger.of("MainCoordinator")
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        log.debug("MainCoordinator deinit")
    }
    
    func start() {
        let viewController = MainViewController()
        viewController.viewModel = MainViewModel(delegate: self)
        navigationController.viewControllers = [viewController]
    }
}

extension MainCoordinator: MainViewModelDelegate {
    func loggedOut() {
        delegate?.finished(mainCoordinator: self)
    }
}
