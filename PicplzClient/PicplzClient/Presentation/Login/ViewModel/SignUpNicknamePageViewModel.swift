//
//  SignUpNicknamePageViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/17/25.
//

import Foundation
import Combine
import OSLog

final class SignUpNicknamePageViewModel: SignUpNicknamePageViewModelProtocol {
    var delegate: SignUpViewModelDelegate?
    var currentPage: Int = 0
    var signUpSession: SignUpSession?
    
    @Published var nextButtonEnabled = false
    var nextButtonEnabledPublisher: Published<Bool>.Publisher {
        $nextButtonEnabled
    }
    
    @Published var nicknameCheckResult: NicknameCheckResult = .valid
    var nicknameCheckResultPublisher: Published<NicknameCheckResult>.Publisher {
        $nicknameCheckResult
    }
    
    var nicknameInput: String?
    
    private var log = Logger.of("SignUpViewModel")
    
    func nicknameDidSet(nickname: String) {
        if validateNickname(for: nickname) {
            log.debug("사용할 수 있는 닉네임: \(nickname)")
            self.nicknameInput = nickname
            nextButtonEnabled = true
            nicknameCheckResult = .valid
            signUpSession?.nickname = nickname
        } else {
            log.debug("사용 불가한 닉네임: \(nickname)")
            self.nicknameInput = nil
            nextButtonEnabled = false
            nicknameCheckResult = .invalidFormat
        }
    }
    
    func validateNickname(for nickname: String) -> Bool {
        if nickname.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        // 앞뒤 공백 검사
        if nickname.trimmingCharacters(in: .whitespaces) != nickname {
            return false
        }
        
        // 한글, 영문, 숫자, 공백만 허용
        let pattern = #"^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9 ]+$"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        
        let range = NSRange(location: 0, length: nickname.utf16.count)
        return regex.firstMatch(in: nickname, options: [], range: range) != nil
    }
    
    func nextButtonDidTapped() {
        log.debug("SignUpNicknamePageViewModel nextButtonDidTapped")
        delegate?.goToNextPage(current: currentPage, session: signUpSession)
    }
}
