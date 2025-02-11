//
//  GetAuthInfoUseCase.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

protocol GetAuthInfoUseCase {
    func getUserInfo() -> AuthUser?
    func getAccessToken() -> String?
}

final class GetAuthInfoUseCaseImpl: GetAuthInfoUseCase {
    let authManaging: AuthManaging
    
    init(authManaging: AuthManaging) {
        self.authManaging = authManaging
    }
    
    func getUserInfo() -> AuthUser? {
        authManaging.currentUser
    }
    
    func getAccessToken() -> String? {
        authManaging.accessToken
    }
}
