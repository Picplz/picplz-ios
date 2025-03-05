//
//  LoginViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Combine

final class OnboardingViewModel: OnboardingViewModelProtocol {
    var delegate: OnboardingViewModelDelegate?
    
    @Published var currentPageIndex = 0
    var currentPageIndexPublisher: Published<Int>.Publisher {
        $currentPageIndex
    }
    
    @Published var showLoginButton = false
    var showLoginButtonPublisher: Published<Bool>.Publisher {
        $showLoginButton
    }
    
    let onboardingPages = OnboardingPage.pages
    
    func currentPageChanged(pageIndex: Int) {
        currentPageIndex = pageIndex
        showLoginButton = pageIndex == onboardingPages.count - 1
    }
    
    func kakaoLoginButtonTapped() {
        delegate?.goToLogin(authProvider: .kakao)
    }
}
