//
//  CustomerHomeCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 3/10/25.
//

import UIKit
import Swinject
import OSLog

final class CustomerMapCoordinator: TabBarItemCoordinator {
    var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    private let container: Container
    private let log = Logger.of("CustomerMapCoordinator")
    
    let tabBarTitle: String
    let tabBarImage: UIImage?
    let tabBarIndex: Int
    
    init(container: Container, tabBarTitle: String, tabBarImage: UIImage?, tabBarIndex: Int) {
        self.container = container
        self.tabBarTitle = tabBarTitle
        self.tabBarImage = tabBarImage
        self.tabBarIndex = tabBarIndex
    }
    
    func start() {
        guard let viewController = container.resolve(CustomerMapViewController.self) else {
            log.error("CustomerMapViewController could not be resolved")
            fatalError("CustomerMapViewController could not be resolved")
        }
        navigationController.viewControllers = [viewController]
        navigationController.tabBarItem = UITabBarItem(title: tabBarTitle, image: tabBarImage, tag: tabBarIndex)
    }
}
