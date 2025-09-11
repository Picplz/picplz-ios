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

    @Published var havingCareer: Bool?
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
            .map { careerType in
                self.signUpSession?.photoCareerType = careerType
                return careerType
            }
            .eraseToAnyPublisher()
    }

    private var log = Logger.of("SignUpPhotographerCareerTypePageViewModel")

    func informationButtonTapped() {
        isInformationModalActive.toggle()
    }

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
        let havingCareer = self.havingCareer ?? false

        if shouldShowPrompt && havingCareer { // 프롬프트 표시 중 + 경력 있음 -> 설정 뷰 표시
            shouldShowPrompt = false
            nextButtonEnabled = false
        } else { // 다음 페이지 이동
            var adjustedCurrentPage = self.currentPage
            if !havingCareer {
                adjustedCurrentPage += 1 // 경험 없음을 선택한 경우 다다음 페이지로 이동
            }

            delegate?.goToNextPage(current: adjustedCurrentPage, session: signUpSession)
        }
    }
}
