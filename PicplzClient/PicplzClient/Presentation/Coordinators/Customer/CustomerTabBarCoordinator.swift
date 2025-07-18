//
//  CustomerTabBarCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 3/10/25.
//

import UIKit
import Swinject
import OSLog

protocol CustomerTabBarCoordinatorDelegate: AnyObject {
    func switchToPhotographer(customerCoordinator: CustomerTabBarCoordinator)
    func loggedOut(customerCoordinator: CustomerTabBarCoordinator)
}

class CustomerTabBarCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    weak var delegate: CustomerTabBarCoordinatorDelegate?
    let tabBarController: UITabBarController // TODO: Tabbar 커스텀 스타일링
    private let container: Container
    private let log = Logger.of("CustomerTabBarCoordinator")
    
    private lazy var homeCoordinator = CustomerHomeCoordinator(tabBarTitle: "홈", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 0)
    private lazy var mapCoordinator = CustomerMapCoordinator(container: container, tabBarTitle: "지도", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 1)
    private lazy var feedCoordinator = CustomerFeedCoordinator(tabBarTitle: "피드", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 2)
    private lazy var chatCoordinator = CustomerChatCoordinator(tabBarTitle: "채팅", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 3)
    private lazy var myPageCoordinator = CustomerMyPageCoordinator(tabBarTitle: "마이페이지", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 4)
    
    init(container: Container) {
        self.tabBarController = UITabBarController()
        self.container = container
        
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
        
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .ppWhite
        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            mapCoordinator.navigationController,
            feedCoordinator.navigationController,
            chatCoordinator.navigationController,
            myPageCoordinator.navigationController,
        ]
        tabBarController.selectedIndex = 0
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
