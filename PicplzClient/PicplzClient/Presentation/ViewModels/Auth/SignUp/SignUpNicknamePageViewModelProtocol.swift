//
//  SignUpViewModelProtocol.swift
//  PicplzClient
//
//  Created by 임영택 on 2/17/25.
//

import Combine

protocol SignUpNicknamePageViewModelProtocol: SignUpVIewModelProtocol {
    var nicknameCheckResult: NicknameCheckResult { get }
    var nicknameCheckResultPublisher: Published<NicknameCheckResult>.Publisher { get }

    func nicknameDidSet(nickname: String)
    func nextButtonDidTapped()
}

enum NicknameCheckResult {
    case valid
    case duplicated
    case invalidFormat
}
