//
//  AuthUser.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation

struct AuthUser: CustomStringConvertible, Codable {
    let sub: Int
    let nickname: String
    let profileImageUrl: String?
    var memberType: MemberType?
    
    // MARK: Social Login
    let socialEmail: String
    let socialCode: String
    let socialProvider: SocialProvider
    
    // TODO: 작가의 경우 주촬영지, 촬영 기기 프로퍼티 정의 필요
    
    enum MemberType: String, Codable {
        case customer = "CUSTOMER"
        case photographer = "PHOTOGRAPHER"
    }
    
    var description: String {
        "AuthUser: "
        + "/ nickname: \(nickname) "
        + "/ profileImageUrl: \(String(describing: profileImageUrl)) "
        + "/ memberType: \(String(describing: memberType)) "
    }
}

enum SocialProvider: String, Codable {
    case kakao = "KAKAO"
    case apple = "APPLE"
}
