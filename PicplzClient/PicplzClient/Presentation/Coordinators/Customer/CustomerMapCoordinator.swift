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
    private(set) var navigationController = UIPicplzNavigationController()
    private let container: Container
    private let log = Logger.of("CustomerMapCoordinator")

    let tabBarTitle: String
    let tabBarImage: UIImage?
    let tabBarSelectedImage: UIImage?
    let tabBarIndex: Int

    init(container: Container, tabBarTitle: String, tabBarImage: UIImage?, tabBarSelectedImage: UIImage?, tabBarIndex: Int) {
        self.container = container
        self.tabBarTitle = tabBarTitle
        self.tabBarImage = tabBarImage
        self.tabBarSelectedImage = tabBarSelectedImage
        self.tabBarIndex = tabBarIndex
    }

    func start() {
        guard let viewController = container.resolve(CustomerMapViewController.self) else {
            log.error("CustomerMapViewController could not be resolved")
            fatalError("CustomerMapViewController could not be resolved")
        }
        navigationController.viewControllers = [viewController]
        viewController.viewModel.delegate = self
        navigationController.tabBarItem = UITabBarItem(title: tabBarTitle, image: tabBarImage, tag: tabBarIndex)
        navigationController.tabBarItem.selectedImage = tabBarSelectedImage
    }
}

extension CustomerMapCoordinator: CustomerMapViewModelDelegate {
    func selectPhotographerDetail(photographerId: Int) {
        navigateToPhotographerDetail(photographerId: photographerId)
    }

    private func navigateToPhotographerDetail(photographerId: Int) {
        guard let viewController = container.resolve(PhotographerDetailViewController.self) else {
            log.error("PhotographerDetailViewController could not be resolved")
            fatalError("PhotographerDetailViewController could not be resolved")
        }
        viewController.viewModel.photographerId = photographerId
        navigationController.viewControllers.append(viewController)
    }
}
