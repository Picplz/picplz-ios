//
//  CustomerHomeCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 3/10/25.
//

import UIKit

final class CustomerMapCoordinator: TabBarItemCoordinator {
    var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    
    let tabBarTitle: String
    let tabBarImage: UIImage?
    let tabBarIndex: Int
    
    init(tabBarTitle: String, tabBarImage: UIImage?, tabBarIndex: Int) {
        self.tabBarTitle = tabBarTitle
        self.tabBarImage = tabBarImage
        self.tabBarIndex = tabBarIndex
    }
    
    func start() {
        let viewController = CustomerMapViewController()
        navigationController.viewControllers = [viewController]
        navigationController.tabBarItem = UITabBarItem(title: tabBarTitle, image: tabBarImage, tag: tabBarIndex)
    }
}
