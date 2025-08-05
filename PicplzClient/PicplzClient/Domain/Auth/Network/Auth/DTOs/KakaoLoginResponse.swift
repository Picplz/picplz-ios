//
//  KakaoLoginResponse.swift
//  PicplzClient
//
//  Created by 임영택 on 8/5/25.
//

import Foundation

struct KakaoLoginResponse: Decodable {
    let timestamp: String
    let statusCode: Int
    let message: String
    let data: KakaoLoginResponseData
    
    struct KakaoLoginResponseData: Decodable {
        let socialCode: String
        let socialEmail: String?
        let socialProvider: String
        let token: KakaoLoginToken?
        let registered: Bool
    }
}
