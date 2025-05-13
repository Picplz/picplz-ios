//
//  LoginViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Combine

final class OnboardingViewModel: OnboardingViewModelProtocol {
    var delegate: OnboardingViewModelDelegate?
    var loginUseCase: LoginUseCase?
    
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
        Task {
            do {
                try await loginUseCase?.login()
                print("loggedIn")
                
                await MainActor.run {
                    delegate?.loggedIn()
                }
            } catch {
                print("login failed")
                print(error)
            }
        }
    }
}
