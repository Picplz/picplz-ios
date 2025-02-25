//
//  AuthUser.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation

struct AuthUser: CustomStringConvertible {
    let name: String
    let nickname: String
    let birth: Date
    let role: String
    let kakaoEmail: String
    let profileImageUrl: String
    var memberType: MemberType?
    var photoCareerType: CareerType?
    var photoCareerYears: Int?
    var photoCareerMonths: Int?
    var photoSpecializedThemes: [String]?
    
    enum MemberType {
        case customer
        case photographer
    }
    
    enum CareerType {
        case major // 사진 전공
        case job // 수익 창출
        case influencer // SNS 계정 운영
    }
    
    var description: String {
        "AuthUser: name: \(name) "
        + "/ nickname: \(nickname) "
        + "/ birth: \(birth) "
        + "/ role: \(role) "
        + "/ kakaoEmail: \(kakaoEmail) "
        + "/ profileImageUrl: \(String(describing: profileImageUrl)) "
        + "/ memberType: \(String(describing: memberType)) "
        + "/ photoCareerType: \(String(describing: photoCareerType)) "
        + "/ photoCareerYears: \(String(describing: photoCareerYears)) "
        + "/ photoCareerMonths: \(String(describing: photoCareerMonths)) "
        + "/ photoSpecializedThemes: \(String(describing: photoSpecializedThemes))"
    }
}
