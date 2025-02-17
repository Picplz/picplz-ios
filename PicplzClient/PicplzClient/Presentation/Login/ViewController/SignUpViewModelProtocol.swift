//
//  SignUpViewModelProtocol.swift
//  PicplzClient
//
//  Created by 임영택 on 2/17/25.
//

import Combine

protocol SignUpViewModelProtocol {
    var nextButtonEnabled: Bool { get }
    var nextButtonEnabledPublisher: Published<Bool>.Publisher { get }
    
    var nicknameCheckResult: NicknameCheckResult { get }
    var nicknameCheckResultPublisher: Published<NicknameCheckResult>.Publisher { get }
    
    func nicknameDidSet(nickname: String)
}

enum NicknameCheckResult {
    case valid
    case duplicated
    case invalidFormat
}

