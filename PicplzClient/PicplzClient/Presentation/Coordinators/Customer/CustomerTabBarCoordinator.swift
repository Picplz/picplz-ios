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
    let tabBarController: CustomTabBarController // TODO: Tabbar 커스텀 스타일링
    private let container: Container
    private let log = Logger.of("CustomerTabBarCoordinator")
    
    private lazy var homeCoordinator = CustomerHomeCoordinator(
        tabBarTitle: "홈",
        tabBarImage: UIImage(resource: .homeTabDefault),
        tabBarSelectedImage: UIImage(resource: .homeTabSelected),
        tabBarIndex: 0
    )
    private lazy var mapCoordinator = CustomerMapCoordinator(
        container: container,
        tabBarTitle: "바로 촬영",
        tabBarImage: UIImage(resource: .mapTabDefault),
        tabBarSelectedImage: UIImage(resource: .mapTabSelected),
        tabBarIndex: 1
    )
    private lazy var chatCoordinator = CustomerChatCoordinator(
        tabBarTitle: "채팅",
        tabBarImage: UIImage(resource: .chatTabDefault),
        tabBarSelectedImage: UIImage(resource: .chatTabSelected),
        tabBarIndex: 2
    )
    private lazy var myPageCoordinator = CustomerMyPageCoordinator(
        tabBarTitle: "마이페이지",
        tabBarImage: UIImage(resource: .myPageTabDefault),
        tabBarSelectedImage: UIImage(resource: .myPageTabSelected),
        tabBarIndex: 3
    )
    
    init(container: Container) {
        self.tabBarController = CustomTabBarController()
        self.container = container
        
        homeCoordinator.delegate = self
    }
    
    deinit {
        log.debug("CustomerTabBarCoordinator deinit")
    }
    
    func start() {
        homeCoordinator.start()
        mapCoordinator.start()
        chatCoordinator.start()
        myPageCoordinator.start()
        
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .ppWhite
        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            mapCoordinator.navigationController,
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
