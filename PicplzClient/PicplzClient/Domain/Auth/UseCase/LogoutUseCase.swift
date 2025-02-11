//
//  LoginUseCase.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation

protocol LogoutUseCase {
    func logout()
}

final class LogoutUseCaseImpl: LogoutUseCase {
    let authManaging: AuthManaging
    
    init(authManaging: AuthManaging) {
        self.authManaging = authManaging
    }
    
    func logout() {
        authManaging.logout()
    }
}
