//
//  AuthManaging.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation

protocol AuthManaging {
    var currentUser: AuthUser? { get }
    var isLogin: Bool { get }
    var accessToken: String? { get }
    var refreshToken: String? { get }
    
    func updateSocialInfo(socialInfo: SocialInfo)
    func login(tokens: Tokens)
    func logout()
    func validateToken() -> Bool
    func updateUserInfo(user currentUserEntity: AuthUser)
}
