//
//  AuthUser.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation

struct AuthUserModel: Codable {
    let name: String
    let nickname: String
    let birth: Date
    let role: String
    let kakaoEmail: String
    let profileImageUrl: String
    
    static func from(entity: AuthUser) -> AuthUserModel {
        AuthUserModel(name: entity.name, nickname: entity.nickname, birth: entity.birth, role: entity.role, kakaoEmail: entity.kakaoEmail, profileImageUrl: entity.profileImageUrl)
    }
    
    func toEntity() -> AuthUser {
        AuthUser(name: name, nickname: nickname, birth: birth, role: role, kakaoEmail: kakaoEmail, profileImageUrl: profileImageUrl)
    }
}
