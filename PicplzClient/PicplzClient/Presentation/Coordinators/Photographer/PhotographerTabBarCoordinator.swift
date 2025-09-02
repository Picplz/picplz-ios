//
//  PhotographerTabBarCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 3/10/25.
//

import UIKit
import OSLog

protocol PhotographerTabBarCoordinatorDelegate: AnyObject {
    func switchToCustomer(photographerCoordinator: PhotographerTabBarCoordinator)
    func loggedOut(photographerCoordinator: PhotographerTabBarCoordinator)
}

class PhotographerTabBarCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    weak var delegate: PhotographerTabBarCoordinatorDelegate?
    let tabBarController: UITabBarController // FIXME: Tabbar 커스텀 스타일링
    private let log = Logger.of("PhotographerTabBarCoordinator")
    
    private lazy var homeCoordinator = PhotographerHomeCoordinator(
        tabBarTitle: "홈",
        tabBarImage: UIImage(resource: .homeTabDefault),
        tabBarSelectedImage: UIImage(resource: .homeTabSelected),
        tabBarIndex: 0
    )
    private lazy var mapCoordinator = PhotographerMapCoordinator(
        tabBarTitle: "지도",
        tabBarImage: UIImage(resource: .mapTabDefault),
        tabBarSelectedImage: UIImage(resource: .mapTabSelected),
        tabBarIndex: 1
    )
    private lazy var chatCoordinator = PhotographerChatCoordinator(
        tabBarTitle: "채팅",
        tabBarImage: UIImage(resource: .chatTabDefault),
        tabBarSelectedImage: UIImage(resource: .chatTabSelected),
        tabBarIndex: 2
    )
    private lazy var myPageCoordinator = PhotographerMyPageCoordinator(
        tabBarTitle: "마이페이지",
        tabBarImage: UIImage(resource: .myPageTabDefault),
        tabBarSelectedImage: UIImage(resource: .myPageTabSelected),
        tabBarIndex: 3
    )
    
    init() {
        self.tabBarController = UITabBarController()
        
        homeCoordinator.delegate = self
    }
    
    deinit {
        log.debug("PhotographerTabBarCoordinator deinit")
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

extension PhotographerTabBarCoordinator: PhotographerHomeCoordinatorDelegate {
    func switchToCustomer(homeCoordinator: PhotographerHomeCoordinator) {
        self.delegate?.switchToCustomer(photographerCoordinator: self)
    }
    
    func loggedOut(homeCoordinator: PhotographerHomeCoordinator) {
        self.delegate?.loggedOut(photographerCoordinator: self)
    }
}
