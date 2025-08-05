//
//  KakaoLoginToken.swift
//  PicplzClient
//
//  Created by 임영택 on 8/5/25.
//

import Foundation

struct KakaoLoginToken: Decodable {
    let grantType: String
    let accessToken: String
    let refreshToken: String
    let accessTokenExpires: Int
    let accessTokenExpiresDate: Date
}
