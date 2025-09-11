//
//  PhotographerChatCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 3/10/25.
//

import UIKit

final class PhotographerChatCoordinator: TabBarItemCoordinator {
    var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()

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
        let viewController = UIViewController()
        viewController.view.backgroundColor = .green
        navigationController.viewControllers = [viewController]
        navigationController.tabBarItem = UITabBarItem(title: tabBarTitle, image: tabBarImage, tag: tabBarIndex)
        navigationController.tabBarItem.selectedImage = tabBarSelectedImage
    }
}
