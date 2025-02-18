//
//  SignUpProfileImageSettingViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/18/25.
//

import Combine
import OSLog

final class SignUpProfileImageSettingViewModel: SignUpProfileImageSettingViewModelProtocol {
    var delegate: SignUpViewModelDelegate?
    var currentPage: Int = 0
    var signUpSession: SignUpSession? {
        didSet {
            userNickname = signUpSession?.nickname ?? ""
        }
    }
    
    @Published private(set) var nextButtonTitle: String = "다음에 설정하기"
    var nextButtonTitlePublisher: Published<String>.Publisher {
        $nextButtonTitle
    }
    
    @Published private(set) var informationLabelText: String = "프로필 이미지를\n설정해 주세요."
    var informationLabelTextPublisher: Published<String>.Publisher {
        $informationLabelText
    }
    
    @Published private(set) var nextButtonEnabled: Bool = true
    var nextButtonEnabledPublisher: Published<Bool>.Publisher {
        $nextButtonEnabled
    }
    
    @Published private(set) var userNickname: String = ""
    var userNicknamePublisher: Published<String>.Publisher {
        $userNickname
    }
    
    @Published private(set) var profileImagePath: URL? = nil
    var profileImagePathPublisher: AnyPublisher<URL, Never> {
        $profileImagePath
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    private let log = Logger.of("SignUpProfileImageSettingViewModel")
    
    func nextButtonDidTapped() {
        log.debug("SignUpProfileImageSettingViewModel nextButtonDidTapped")
        delegate?.goToNextPage(current: currentPage, session: self.signUpSession)
    }
    
    func profileImageSelected(path profileImagePath: URL) {
        self.profileImagePath = profileImagePath
        self.nextButtonTitle = "다음"
        self.informationLabelText = "회원 타입 설정으로\n넘어갈게요."
        signUpSession?.profileImageUrl = profileImagePath
    }
}
