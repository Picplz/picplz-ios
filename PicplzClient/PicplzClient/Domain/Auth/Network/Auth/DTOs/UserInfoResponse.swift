//
//  UserInfoResponseData.swift
//  PicplzClient
//
//  Created by 임영택 on 9/1/25.
//

import Foundation

struct UserInfoResponse: Decodable {
    let id: Int
    let nickname: String
    let role: String
    let socialEmail: String
    let socialProvider: String
    let socialCode: String
}
