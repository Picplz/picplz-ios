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
    private let navigationController: UINavigationController
    private let log = Logger.of("PhotographerTabBarCoordinator")
    
    private let homeCoordinator = PhotographerHomeCoordinator(tabBarTitle: "홈", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 0)
    private let mapCoordinator = PhotographerMapCoordinator(tabBarTitle: "지도", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 1)
    private let feedCoordinator = PhotographerFeedCoordinator(tabBarTitle: "피드", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 2)
    private let chatCoordinator = PhotographerChatCoordinator(tabBarTitle: "채팅", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 3)
    private let myPageCoordinator = PhotographerMyPageCoordinator(tabBarTitle: "마이페이지", tabBarImage: UIImage(named: "StarBlack"), tabBarIndex: 4)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        homeCoordinator.delegate = self
    }
    
    deinit {
        log.debug("PhotographerTabBarCoordinator deinit")
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

extension PhotographerTabBarCoordinator: PhotographerHomeCoordinatorDelegate {
    func switchToCustomer(homeCoordinator: PhotographerHomeCoordinator) {
        self.delegate?.switchToCustomer(photographerCoordinator: self)
    }
    
    func loggedOut(homeCoordinator: PhotographerHomeCoordinator) {
        self.delegate?.loggedOut(photographerCoordinator: self)
    }
}
