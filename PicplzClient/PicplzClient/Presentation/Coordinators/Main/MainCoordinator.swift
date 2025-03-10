//
//  MainCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit
import OSLog
import Swinject

protocol MainCoordinatorDelegate: AnyObject {
    func finished(mainCoordinator: MainCoordinator)
}

final class MainCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    weak var delegate: MainCoordinatorDelegate?
    private let navigationController: UINavigationController
    private let container: Container
    private let authManaging: AuthManaging
    private var log = Logger.of("MainCoordinator")
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
        
        if let authManaging = container.resolve(AuthManaging.self) {
            self.authManaging = authManaging
        } else {
            log.error("AuthManaging could not be resolved...")
            preconditionFailure("AuthManaging could not be resolved...")
        }
    }
    
    deinit {
        log.debug("MainCoordinator deinit")
    }
    
    func start() {
        guard let currentUser = authManaging.currentUser,
        let memberType = currentUser.memberType else {
            delegate?.finished(mainCoordinator: self)
            return
        }
        
        /**
         FIXME: 작가의 경우 전환이 가능하므로 currentUser의 memberType을 바로 바라보지 말고
         UserDefaults 등으로 관리해야 할 듯
         */
        if case .customer = memberType {
            startCustomer()
        } else if case .photographer = memberType {
            startPhotographer()
        } else {
            delegate?.finished(mainCoordinator: self)
        }
    }
    
    func startCustomer() {
        let coordinator = CustomerTabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }
    
    func startPhotographer() {
        let coordinator = PhotographerCoordinator(navigationController: navigationController, container: container)
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }
    
    func loggedOut(_ childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
        delegate?.finished(mainCoordinator: self)
    }
    
    func switchToAnother(_ childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
        
        if childCoordinator is CustomerTabBarCoordinator {
            startPhotographer()
            return
        }
        
        if childCoordinator is PhotographerCoordinator {
            startCustomer()
            return
        }
        
        log.warning("unexpected child coordinator: \(String(describing: childCoordinator.self))")
    }
}

extension MainCoordinator: CustomerTabBarCoordinatorDelegate {
    func switchToPhotographer(customerCoordinator: CustomerTabBarCoordinator) {
        switchToAnother(customerCoordinator)
    }
    
    func loggedOut(customerCoordinator: CustomerTabBarCoordinator) {
        loggedOut(customerCoordinator)
    }
}

extension MainCoordinator: PhotographerCoordinatorDelegate {
    func switchToCustomer(photographerCoordinator: PhotographerCoordinator) {
        switchToAnother(photographerCoordinator)
    }
    
    func loggedOut(photographerCoordinator: PhotographerCoordinator) {
        loggedOut(photographerCoordinator)
    }
}

