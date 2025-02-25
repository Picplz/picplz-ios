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
    
    @Published var nextButtonEnabled: Bool = false
    var nextButtonEnabledPublisher: Published<Bool>.Publisher {
        $nextButtonEnabled
    }
    
    @Published var isInformationModalActive: Bool = false
    var isInformationModalActivePublisher: Published<Bool>.Publisher {
        $isInformationModalActive
    }
    
    
    @Published var havingCareer: Bool? = nil
    var havingCareerPublisher: Published<Bool?>.Publisher {
        $havingCareer
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
    
//    func careerYesButtonTapped() {
//        shouldShowPrompt = false
//    }
//    
//    func careerNoButtonTapped() {
//        delegate?.goToNextPage(current: currentPage + 1, session: signUpSession) // skip next page
//    }
    func careerYesButtonTapped() {
        havingCareer = true
        nextButtonEnabled = true
    }
    
    func careerNoButtonTapped() {
        havingCareer = false
        nextButtonEnabled = true
    }
    
    func careerTypeSelected(for careerType: SignUpSession.CareerType) {
        log.debug("careerTypeSelected - \(String(describing: careerType))")
        selectedCareerType = careerType
    }
    
    func nextButtonDidTapped() {
        if shouldShowPrompt && (havingCareer ?? false) { // 프롬프트 표시 중 + 경력 있음 -> 설정 뷰 표시
            shouldShowPrompt = false
            nextButtonEnabled = false
        } else { // 다음 페이지 이동
            delegate?.goToNextPage(current: currentPage, session: signUpSession)
        }
    }
}
