//
//  AuthUser.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation

struct AuthUser: CustomStringConvertible, Codable {
    // TODO: 프로퍼티 정리 필요
    let sub: Int
    let nickname: String
    let profileImageUrl: String?
    var memberType: MemberType?
    var photoCareerType: CareerType?
    var photoCareerYears: Int?
    var photoCareerMonths: Int?
    var photoSpecializedThemes: [String]?
    
    // MARK: Social Login
    let socialEmail: String
    let socialCode: String
    let socialProvider: SocialProvider
    
    enum MemberType: String, Codable {
        case customer = "CUSTOMER"
        case photographer = "PHOTOGRAPHER"
    }
    
    enum CareerType: Codable {
        case major // 사진 전공
        case job // 수익 창출
        case influencer // SNS 계정 운영
    }
    
    var description: String {
        "AuthUser: "
        + "/ nickname: \(nickname) "
        + "/ profileImageUrl: \(String(describing: profileImageUrl)) "
        + "/ memberType: \(String(describing: memberType)) "
        + "/ photoCareerType: \(String(describing: photoCareerType)) "
        + "/ photoCareerYears: \(String(describing: photoCareerYears)) "
        + "/ photoCareerMonths: \(String(describing: photoCareerMonths)) "
        + "/ photoSpecializedThemes: \(String(describing: photoSpecializedThemes))"
    }
}

enum SocialProvider: String, Codable {
    case kakao = "KAKAO"
    case apple = "APPLE"
}
