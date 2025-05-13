//
//  SendSignUpRequestUseCase.swift
//  PicplzClient
//
//  Created by 임영택 on 2/25/25.
//

import Foundation

protocol SendSignUpRequestUseCase {
    func execute(signUpSession: SignUpSession)
}

final class SendSignUpRequestUseCaseImpl: SendSignUpRequestUseCase {
    let authManaging: AuthManaging
    
    init(authManaging: AuthManaging) {
        self.authManaging = authManaging
    }
    
    func execute(signUpSession: SignUpSession) {
        // TODO: send signin request to server
        
        storeUserInfo(signUpSession: signUpSession)
    }
    
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
        
        let careerType: AuthUser.CareerType?
        switch signUpSession.photoCareerType {
        case .major:
            careerType = AuthUser.CareerType.major
        case .job:
            careerType = AuthUser.CareerType.job
        case .influencer:
            careerType = AuthUser.CareerType.influencer
        case .none:
            careerType = nil
        }
        
        let newAuthUser = AuthUser(sub: savedAuthUser.sub, name: savedAuthUser.name, nickname: signUpSession.nickname, birth: savedAuthUser.birth, role: savedAuthUser.role, kakaoEmail: savedAuthUser.kakaoEmail, profileImageUrl: signUpSession.profileImageUrl?.path ?? "", memberType: memberType, photoCareerType: careerType, photoCareerYears: signUpSession.photoCareerYears, photoCareerMonths: signUpSession.photoCareerMonths, photoSpecializedThemes: signUpSession.photoSpecializedThemes)
        
        authManaging.updateUserInfo(user: newAuthUser)
    }
}
