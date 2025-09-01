//
//  SendSignUpRequestUseCase.swift
//  PicplzClient
//
//  Created by 임영택 on 2/25/25.
//

import Foundation
import os.log

protocol SendSignUpRequestUseCase {
    func execute(signUpSession: SignUpSession)
}

final class SendSignUpRequestUseCaseImpl: SendSignUpRequestUseCase {
    let authManaging: AuthManaging
    let customerRequests: CustomerRequestable
    
    private let logger = Logger.of("SendSignUpRequestUseCaseImpl")
    
    init(
        authManaging: AuthManaging,
        customerRequests: CustomerRequestable
    ) {
        self.authManaging = authManaging
        self.customerRequests = customerRequests
    }
    
    func execute(signUpSession: SignUpSession) {
        Task { @MainActor in
            do {
                if signUpSession.memberType == .customer {
                    guard let socialCode = authManaging.currentUser?.socialCode else {
                        throw DomainError.validationError("Social Coode가 없습니다")
                    }
                    
                    guard let socialProvider = authManaging.currentUser?.socialProvider else {
                        throw DomainError.validationError("Social Provider가 없습니다")
                    }
                    
                    try await customerRequests.create(registerDto: CustomerRegisterDTO(
                        nickname: signUpSession.nickname,
                        socialEmail: authManaging.currentUser?.socialEmail ?? "",
                        socialCode: socialCode,
                        socialProvider: socialProvider.rawValue
                    ))
                } else {
                    // TODO: 작가 회원가입
                }
                storeUserInfo(signUpSession: signUpSession)
            } catch {
                logger.error("회원가입에 실패했습니다. \(error)")
            }
        }
    }
    
    /// 회원가입 페이지에서 입력한 내용을 로컬에 저장한다
    private func storeUserInfo(signUpSession: SignUpSession) {
        guard let savedAuthUser = authManaging.currentUser else { return }
        
        let memberType: AuthUser.MemberType?
        switch signUpSession.memberType {
        case .customer:
            memberType = AuthUser.MemberType.customer
        case .photographer:
            memberType = AuthUser.MemberType.photographer
        case .none:
            memberType = nil
        }
        
        let newAuthUser = AuthUser(
            sub: savedAuthUser.sub,
            nickname: signUpSession.nickname,
            profileImageUrl: signUpSession.profileImageUrl?.absoluteString,
            memberType: memberType,
            socialEmail: savedAuthUser.socialEmail,
            socialCode: savedAuthUser.socialCode,
            socialProvider: savedAuthUser.socialProvider
        )
        
        authManaging.updateUserInfo(user: newAuthUser)
    }
}
