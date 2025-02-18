//
//  SignUpCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 2/18/25.
//

import UIKit
import Swinject
import OSLog

protocol SignUpCoordinatorDelegate: AnyObject {
    func finished(signUpCoordinator: SignUpCoordinator)
}

final class SignUpCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let container: Container
    weak var delegate: SignUpCoordinatorDelegate?
    
    private var currentPage: Page = .nicknameSetting
    private let viewControllerAndViewModelPairs: [(UIViewController.Type, Any.Type)] = [
        (SignUpNicknamePageViewController.self, SignUpNicknamePageViewModelProtocol.self)
    ]
    private let signUpSession = SignUpSession()
    
    private var log = Logger.of("SignUpCoordinator")
    
    init(navigationController: UINavigationController, container: Container) {
        self.container = container
        self.navigationController = navigationController
    }
    
    deinit {
        log.debug("SignUpCoordinator deinit")
    }
    
    
    func start() {
        showCurrentPage()
    }
    
    func showCurrentPage() {
        let nextVc: UIViewController
        
        switch currentPage {
        case .nicknameSetting:
            guard let vc = container.resolve(SignUpNicknamePageViewController.self) else {
                preconditionFailure("viewController could not be resolved...")
            }
            vc.viewModel.signUpSession = self.signUpSession
            vc.viewModel.currentPage = 1
            vc.viewModel.delegate = self
            nextVc = vc
        case .profileImageSetting:
            guard let vc = container.resolve(SignUpProfileImagePageViewController.self) else {
                preconditionFailure("viewController could not be resolved...")
            }
            vc.viewModel.signUpSession = self.signUpSession
            vc.viewModel.currentPage = 2
            vc.viewModel.delegate = self
            nextVc = vc
        }
        
        navigationController.pushViewController(nextVc, animated: true)
    }
    
    enum Page: Int, CaseIterable {
        case nicknameSetting = 1
        case profileImageSetting = 2
    }
}

extension SignUpCoordinator: SignUpViewModelDelegate {
    func goToNextPage(current currentPage: Int, session signUpSession: SignUpSession?) {
        log.debug("SignUpCoordinator goToNextPage called... current SignUpSession: \(self.signUpSession)")
        
        if currentPage == Page.allCases.last?.rawValue {
            delegate?.finished(signUpCoordinator: self)
            return
        }
        
        if let nextPage = Page(rawValue: currentPage + 1) {
            self.currentPage = nextPage
            showCurrentPage()
        } else {
            log.error("다음 SignUp 페이지를 로드할 수 없습니다.")
        }
    }
}
