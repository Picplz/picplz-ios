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
    private let resolver: Resolver
    weak var delegate: SignUpCoordinatorDelegate?

    private var currentPage: Page = .nicknameSetting
    private let viewControllerAndViewModelPairs: [(UIViewController.Type, Any.Type)] = [
        (SignUpNicknamePageViewController.self, SignUpNicknamePageViewModelProtocol.self)
    ]
    private let signUpSession = SignUpSession()
    private var signUpUseCase: SendSignUpRequestUseCase!

    private var log = Logger.of("SignUpCoordinator")

    init(navigationController: UINavigationController, resolver: Resolver) {
        self.resolver = resolver
        self.navigationController = navigationController

        self.signUpUseCase = resolver.resolve(SendSignUpRequestUseCase.self)
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
            guard let viewController = resolver.resolve(SignUpNicknamePageViewController.self) else {
                handleViewControllerNotResolved()
                return
            }
            viewController.viewModel.signUpSession = self.signUpSession
            viewController.viewModel.currentPage = currentPage.getPage()
            viewController.viewModel.delegate = self
            nextVc = viewController
        case .profileImageSetting:
            guard let viewController = resolver.resolve(SignUpProfileImagePageViewController.self) else {
                handleViewControllerNotResolved()
                return
            }
            viewController.viewModel.signUpSession = self.signUpSession
            viewController.viewModel.currentPage = currentPage.getPage()
            viewController.viewModel.delegate = self
            nextVc = viewController
        case .memberTypeSetting:
            guard let viewController = resolver.resolve(SignUpMemberTypePageViewController.self) else {
                handleViewControllerNotResolved()
                return
            }
            viewController.viewModel.signUpSession = self.signUpSession
            viewController.viewModel.currentPage = currentPage.getPage()
            viewController.viewModel.delegate = self
            nextVc = viewController
        case .photoCareerTypeSetting:
            guard let viewController = resolver.resolve(SignUpPhotographerCareerTypePageViewController.self) else {
                handleViewControllerNotResolved()
                return
            }
            viewController.viewModel.signUpSession = self.signUpSession
            viewController.viewModel.currentPage = currentPage.getPage()
            viewController.viewModel.delegate = self
            nextVc = viewController
        case .photoCareerPeriodSetting:
            guard let viewController = resolver.resolve(SignUpPhotographerCareerPeriodViewController.self) else {
                handleViewControllerNotResolved()
                return
            }
            viewController.viewModel.signUpSession = self.signUpSession
            viewController.viewModel.currentPage = currentPage.getPage()
            viewController.viewModel.delegate = self
            nextVc = viewController
        case .photoSpecializedThemesSetting:
            guard let viewController = resolver.resolve(SignUpPhotographerThemesPageViewController.self) else {
                handleViewControllerNotResolved()
                return
            }
            viewController.viewModel.signUpSession = self.signUpSession
            viewController.viewModel.currentPage = currentPage.getPage()
            viewController.viewModel.delegate = self
            nextVc = viewController
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
            self.rawValue
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

    private func sendDataToServer() {
        signUpUseCase.execute(signUpSession: signUpSession)
    }
}

extension SignUpCoordinator: SignUpViewModelDelegate {
    func goToNextPage(current currentPageNumber: Int, session signUpSession: SignUpSession?) {
        log.debug("SignUpCoordinator goToNextPage called... current SignUpSession: \(self.signUpSession)")

        guard let currentPage = Page(rawValue: currentPageNumber) else { return }

        if let signUpSession = signUpSession,
           let memberType = signUpSession.memberType,
           currentPage.isLast(to: memberType) {
            sendDataToServer() // MARK: Send sign up requst to server

            guard let viewController = resolver.resolve(SignUpFinishVIewController.self) else {
                handleViewControllerNotResolved()
                return
            }
            viewController.delegate = self
            viewController.nickname = signUpSession.nickname
            viewController.profileImagePath = signUpSession.profileImageUrl
            navigationController.viewControllers = [viewController]
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

extension SignUpCoordinator: SignUpFinishVIewControllerDelegate {
    func didTapFinishButton() {
        delegate?.finished(signUpCoordinator: self)
    }
}
