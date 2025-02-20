//
//  SignUpPhotographerCareerTypePageViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/20/25.
//

import Combine
import OSLog

final class SignUpPhotographerCareerTypePageViewModel: SignUpPhotographerCareerTypePageViewModelProtocol {
    var delegate: SignUpViewModelDelegate?
    var currentPage: Int = 0
    var signUpSession: SignUpSession?
    
    @Published var nextButtonEnabled: Bool = true
    var nextButtonEnabledPublisher: Published<Bool>.Publisher {
        $nextButtonEnabled
    }
    
    @Published var isInformationModalActive: Bool = false
    var isInformationModalActivePublisher: Published<Bool>.Publisher {
        $isInformationModalActive
    }
    
    @Published var shouldShowPrompt: Bool = true
    var shouldShowPromptPublisher: Published<Bool>.Publisher {
        $shouldShowPrompt
    }
    
    @Published var selectedCareerType: SignUpSession.CareerType?
    var selectedCareerTypePublisher: AnyPublisher<SignUpSession.CareerType, Never> {
        $selectedCareerType
            .compactMap { $0 }
            .map({ careerType in
                self.signUpSession?.photoCareerType = careerType
                return careerType
            })
            .eraseToAnyPublisher()
    }
    
    private var log = Logger.of("SignUpPhotographerCareerTypePageViewModel")
    
    func informationButtonTapped() {
        isInformationModalActive.toggle()
    }
    
    func careerYesButtonTapped() {
        shouldShowPrompt = false
    }
    
    func careerNoButtonTapped() {
        delegate?.goToNextPage(current: currentPage + 1, session: signUpSession) // skip next page
    }
    
    func careerTypeSelected(for careerType: SignUpSession.CareerType) {
        log.debug("careerTypeSelected - \(String(describing: careerType))")
        selectedCareerType = careerType
    }
    
    func nextButtonDidTapped() {
        delegate?.goToNextPage(current: currentPage, session: signUpSession)
    }
}
