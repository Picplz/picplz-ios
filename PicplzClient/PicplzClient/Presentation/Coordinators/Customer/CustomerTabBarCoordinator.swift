//
//  CustomerTabBarCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 3/10/25.
//

import UIKit
import OSLog

protocol CustomerTabBarCoordinatorDelegate: AnyObject {
    func switchToPhotographer(customerCoordinator: CustomerTabBarCoordinator)
    func loggedOut(customerCoordinator: CustomerTabBarCoordinator)
}

class CustomerTabBarCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    weak var delegate: CustomerTabBarCoordinatorDelegate?
    private let navigationController: UINavigationController
    private let log = Logger.of("CustomerTabBarCoordinator")
    
    private let homeCoordinator = CustomerHomeCoordinator(tabBarTitle: "홈", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 0)
    private let mapCoordinator = CustomerMapCoordinator(tabBarTitle: "지도", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 1)
    private let feedCoordinator = CustomerFeedCoordinator(tabBarTitle: "피드", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 2)
    private let chatCoordinator = CustomerChatCoordinator(tabBarTitle: "채팅", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 3)
    private let myPageCoordinator = CustomerMyPageCoordinator(tabBarTitle: "마이페이지", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 4)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        homeCoordinator.delegate = self
    }
    
    deinit {
        log.debug("CustomerTabBarCoordinator deinit")
    }
    
    func start() {
        homeCoordinator.start()
        mapCoordinator.start()
        feedCoordinator.start()
        chatCoordinator.start()
        myPageCoordinator.start()
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            mapCoordinator.navigationController,
            feedCoordinator.navigationController,
            chatCoordinator.navigationController,
            myPageCoordinator.navigationController,
        ]
        tabBarController.selectedIndex = 0
        
        navigationController.viewControllers = [tabBarController]
    }
}

extension CustomerTabBarCoordinator: CustomerHomeCoordinatorDelegate {
    func switchToPhotographer(homeCoordinator: CustomerHomeCoordinator) {
        self.delegate?.switchToPhotographer(customerCoordinator: self)
    }
    
    func loggedOut(homeCoordinator: CustomerHomeCoordinator) {
        self.delegate?.loggedOut(customerCoordinator: self)
    }
}
