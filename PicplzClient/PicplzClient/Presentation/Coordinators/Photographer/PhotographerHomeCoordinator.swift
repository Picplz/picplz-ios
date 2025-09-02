//
//  PhotographerHomeCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 3/10/25.
//

import UIKit

protocol PhotographerHomeCoordinatorDelegate: AnyObject {
    func switchToCustomer(homeCoordinator: PhotographerHomeCoordinator)
    func loggedOut(homeCoordinator: PhotographerHomeCoordinator)
}

final class PhotographerHomeCoordinator: TabBarItemCoordinator {
    var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    weak var delegate: PhotographerHomeCoordinatorDelegate?
    
    let tabBarTitle: String
    let tabBarImage: UIImage?
    let tabBarSelectedImage: UIImage?
    let tabBarIndex: Int
    
    init(tabBarTitle: String, tabBarImage: UIImage?, tabBarSelectedImage: UIImage?, tabBarIndex: Int) {
        self.tabBarTitle = tabBarTitle
        self.tabBarImage = tabBarImage
        self.tabBarSelectedImage = tabBarSelectedImage
        self.tabBarIndex = tabBarIndex
    }
    
    func start() {
        let viewController = PhotographerViewController()
        viewController.delegate = self
        navigationController.viewControllers = [viewController]
        navigationController.tabBarItem = UITabBarItem(title: tabBarTitle, image: tabBarImage, tag: tabBarIndex)
        navigationController.tabBarItem.selectedImage = tabBarSelectedImage
    }
}

extension PhotographerHomeCoordinator: PhotographerViewControllerDelegate {
    func switchToCustomer() {
        self.delegate?.switchToCustomer(homeCoordinator: self)
    }
    
    func logOut() {
        self.delegate?.loggedOut(homeCoordinator: self)
    }
}
