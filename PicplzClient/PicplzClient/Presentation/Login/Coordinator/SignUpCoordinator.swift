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
                handleViewControllerNotResolved()
                return
            }
            vc.viewModel.signUpSession = self.signUpSession
            vc.viewModel.currentPage = currentPage.getPage()
            vc.viewModel.delegate = self
            nextVc = vc
        case .profileImageSetting:
            guard let vc = container.resolve(SignUpProfileImagePageViewController.self) else {
                handleViewControllerNotResolved()
                return
            }
            vc.viewModel.signUpSession = self.signUpSession
            vc.viewModel.currentPage = currentPage.getPage()
            vc.viewModel.delegate = self
            nextVc = vc
        case .memberTypeSetting:
            guard let vc = container.resolve(SignUpMemberTypePageViewController.self) else {
                handleViewControllerNotResolved()
                return
            }
            vc.viewModel.signUpSession = self.signUpSession
            vc.viewModel.currentPage = currentPage.getPage()
            vc.viewModel.delegate = self
            nextVc = vc
        case .photoCareerTypeSetting:
            guard let vc = container.resolve(SignUpPhotographerCareerTypePageViewController.self) else {
                handleViewControllerNotResolved()
                return
            }
            vc.viewModel.signUpSession = self.signUpSession
            vc.viewModel.currentPage = currentPage.getPage()
            vc.viewModel.delegate = self
            nextVc = vc
        case .photoCareerPeriodSetting:
            guard let vc = container.resolve(SignUpPhotographerCareerPeriodViewController.self) else {
                handleViewControllerNotResolved()
                return
            }
            vc.viewModel.signUpSession = self.signUpSession
            vc.viewModel.currentPage = currentPage.getPage()
            vc.viewModel.delegate = self
            nextVc = vc
        case .photoSpecializedThemesSetting:
            log.debug("SpecializedThemesSettingPage is not implemented...")
            nextVc = UIViewController()
        }
        
        navigationController.pushViewController(nextVc, animated: true)
    }
    
    enum Page: Int, CaseIterable {
        case nicknameSetting = 1
        case profileImageSetting
        case memberTypeSetting
        case photoCareerTypeSetting
        case photoCareerPeriodSetting
        case photoSpecializedThemesSetting
        
        func getPage() -> Int {
            return self.rawValue
        }
        
        func getLastPage(to memberType: SignUpSession.MemberType) -> Int {
            switch memberType {
            case .customer: return 3
            case .photographer: return 6
            }
        }
        
        func isLast(to memberType: SignUpSession.MemberType) -> Bool {
            self.rawValue == getLastPage(to: memberType)
        }
    }
    
    private func handleViewControllerNotResolved() {
        preconditionFailure("viewController could not be resolved...")
    }
}

extension SignUpCoordinator: SignUpViewModelDelegate {
    func goToNextPage(current currentPageNumber: Int, session signUpSession: SignUpSession?) {
        log.debug("SignUpCoordinator goToNextPage called... current SignUpSession: \(self.signUpSession)")
        
        guard let currentPage = Page(rawValue: currentPageNumber) else { return }
        
        if let signUpSession = signUpSession,
           let memberType = signUpSession.memberType,
           currentPage.isLast(to: memberType) {
            delegate?.finished(signUpCoordinator: self)
            return
        }
        
        if let nextPage = Page(rawValue: currentPage.rawValue + 1) {
            self.currentPage = nextPage
            showCurrentPage()
        } else {
            log.error("다음 SignUp 페이지를 로드할 수 없습니다.")
        }
    }
}
