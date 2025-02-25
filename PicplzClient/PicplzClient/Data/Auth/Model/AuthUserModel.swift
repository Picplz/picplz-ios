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
    var memberType: MemberType?
    var photoCareerType: CareerType?
    var photoCareerYears: Int?
    var photoCareerMonths: Int?
    var photoSpecializedThemes: [String]?
    
    static func from(entity: AuthUser) -> AuthUserModel {
        AuthUserModel(name: entity.name, nickname: entity.nickname, birth: entity.birth, role: entity.role, kakaoEmail: entity.kakaoEmail, profileImageUrl: entity.profileImageUrl, memberType: MemberType.from(entity: entity.memberType), photoCareerType: CareerType.from(entity: entity.photoCareerType), photoCareerYears: entity.photoCareerYears, photoCareerMonths: entity.photoCareerMonths, photoSpecializedThemes: entity.photoSpecializedThemes)
    }
    
    func toEntity() -> AuthUser {
        AuthUser(name: name, nickname: nickname, birth: birth, role: role, kakaoEmail: kakaoEmail, profileImageUrl: profileImageUrl, memberType: memberType?.toEntity(), photoCareerType: photoCareerType?.toEntity(), photoCareerYears: photoCareerYears, photoCareerMonths: photoCareerMonths, photoSpecializedThemes: photoSpecializedThemes)
    }
    
    enum MemberType: Codable {
        case customer
        case photographer
        
        static func from(entity: AuthUser.MemberType?) -> MemberType? {
            guard let entity = entity else { return nil }
            
            switch entity {
            case .customer: return MemberType.customer
            case .photographer: return MemberType.photographer
            }
        }
        
        func toEntity() -> AuthUser.MemberType {
            switch self {
            case .customer: return AuthUser.MemberType.customer
            case .photographer: return AuthUser.MemberType.photographer
            }
        }
    }
    
    enum CareerType: Codable {
        case major // 사진 전공
        case job // 수익 창출
        case influencer // SNS 계정 운영
        
        static func from(entity: AuthUser.CareerType?) -> CareerType? {
            guard let entity = entity else { return nil }
            
            switch entity {
            case .major: return CareerType.major
            case .job: return CareerType.job
            case .influencer: return CareerType.influencer
            }
        }
        
        func toEntity() -> AuthUser.CareerType {
            switch self {
            case .major: return AuthUser.CareerType.major
            case .job: return AuthUser.CareerType.job
            case .influencer: return AuthUser.CareerType.influencer
            }
        }
    }
}
