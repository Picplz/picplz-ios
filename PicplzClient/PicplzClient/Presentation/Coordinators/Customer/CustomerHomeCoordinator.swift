//
//  CustomerHomeCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 3/10/25.
//

import UIKit

protocol CustomerHomeCoordinatorDelegate: AnyObject {
    func switchToPhotographer(homeCoordinator: CustomerHomeCoordinator)
    func loggedOut(homeCoordinator: CustomerHomeCoordinator)
}

final class CustomerHomeCoordinator: TabBarItemCoordinator {
    var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    weak var delegate: CustomerHomeCoordinatorDelegate?
    
    let tabBarTitle: String
    let tabBarImage: UIImage?
    let tabBarIndex: Int
    
    init(tabBarTitle: String, tabBarImage: UIImage?, tabBarIndex: Int) {
        self.tabBarTitle = tabBarTitle
        self.tabBarImage = tabBarImage
        self.tabBarIndex = tabBarIndex
    }
    
    func start() {
        let viewController = CustomerViewController()
        viewController.delegate = self
        navigationController.viewControllers = [viewController]
        navigationController.tabBarItem = UITabBarItem(title: tabBarTitle, image: tabBarImage, tag: tabBarIndex)
    }
}

extension CustomerHomeCoordinator: CustomerViewControllerDelegate {
    func switchToPhotographer() {
        self.delegate?.switchToPhotographer(homeCoordinator: self)
    }
    
    func logOut() {
        self.delegate?.loggedOut(homeCoordinator: self)
    }
}
