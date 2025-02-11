//
//  LoginUseCase.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation

protocol LoginUseCase {
    func login(token: String, expiresDate: Date, user: AuthUser)
}

final class LoginUseCaseImpl: LoginUseCase {
    let authManaging: AuthManaging
    
    init(authManaging: AuthManaging) {
        self.authManaging = authManaging
    }
    
    func login(token: String, expiresDate: Date, user: AuthUser) {
        authManaging.login(accessToken: token, expiresDate: expiresDate, user: user)
    }
}
