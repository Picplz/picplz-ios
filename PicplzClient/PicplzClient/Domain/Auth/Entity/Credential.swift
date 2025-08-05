//
//  Credential.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation

struct SocialInfo {
    let nickname: String?
    let socialEmail: String
    let socialCode: String
    let socialProvider: SocialProvider
}

enum SocialProvider: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
}
