//
//  SignInResponseDTO.swift
//  Networking
//
//  Created by 임영택 on 2/27/26.
//

import Foundation

struct SignInResponseDTO: Codable {
    let socialCode: String
    let socialEmail: String?
    let socialProvider: String // "kakao" 또는 "apple"
    let token: TokenInfo?
    let registered: Bool
}

struct TokenInfo: Codable {
    let grantType: String
    let accessToken: String
    let refreshToken: String
    let accessTokenExpires: Int
    let accessTokenExpiresDate: Date
}
