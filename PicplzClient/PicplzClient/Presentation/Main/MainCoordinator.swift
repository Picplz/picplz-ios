//
//  MainCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit
import OSLog

final class MainCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
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
        navigationController.viewControllers = [viewController]
    }
}
