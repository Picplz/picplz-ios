//
//  OnboardingViewModelProtocol.swift
//  PicplzClient
//
//  Created by 임영택 on 2/10/25.
//

import Combine

protocol OnboardingViewModelProtocol {
    var delegate: OnboardingViewModelDelegate? { get set }
    var loginUseCase: LoginUseCase? { get set }

    var currentPageIndex: Int { get }
    var currentPageIndexPublisher: Published<Int>.Publisher { get }

    var showLoginButton: Bool { get }
    var showLoginButtonPublisher: Published<Bool>.Publisher { get }

    var errorMessage: String? { get }
    var errorMessagePublisher: Published<String?>.Publisher { get }

    var onboardingPages: [OnboardingPage] { get }

    func currentPageChanged(pageIndex: Int)
    func kakaoLoginButtonTapped()
}

protocol OnboardingViewModelDelegate: AnyObject {
    func loggedIn()
    func showSignUp()
}
