//
//  KakaoLoginResponse.swift
//  PicplzClient
//
//  Created by 임영택 on 9/1/25.
//

import Foundation

struct KakaoLoginResponse: Decodable {
    let socialCode: String
    let socialEmail: String?
    let socialProvider: String
    let token: KakaoLoginToken?
    let registered: Bool
}
