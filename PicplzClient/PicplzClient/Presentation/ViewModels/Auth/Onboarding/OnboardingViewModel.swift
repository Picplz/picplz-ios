//
//  LoginViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Combine
import OSLog

final class OnboardingViewModel: OnboardingViewModelProtocol {
    var delegate: OnboardingViewModelDelegate?
    var loginUseCase: LoginUseCase?
    
    private let log = Logger.of("OnboardingViewModel")
    
    @Published var currentPageIndex = 0
    var currentPageIndexPublisher: Published<Int>.Publisher {
        $currentPageIndex
    }
    
    @Published var showLoginButton = false
    var showLoginButtonPublisher: Published<Bool>.Publisher {
        $showLoginButton
    }
    
    @Published var errorMessage: String?
    var errorMessagePublisher: Published<String?>.Publisher {
        $errorMessage
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
                log.info("loggedIn")
                
                await MainActor.run {
                    delegate?.loggedIn()
                }
            } catch {
                if let error = error as? DomainError {
                    if case .notRegisteredUser = error {
                        await MainActor.run {
                            delegate?.showSignUp()
                        }
                        
                        return
                    }
                    
                    errorMessage = error.errorDescription
                } else {
                    errorMessage = error.localizedDescription
                }
                
                log.error("login failed... \(error)")
            }
        }
    }
}
