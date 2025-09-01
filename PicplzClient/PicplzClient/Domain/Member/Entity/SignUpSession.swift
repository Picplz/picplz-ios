//
//  SignUpSession.swift
//  PicplzClient
//
//  Created by 임영택 on 2/18/25.
//

import Foundation

/// 회원가입 세션
final class SignUpSession: CustomStringConvertible {
    /// 닉네임
    var nickname: String = ""
    
    /// 프로필 이미지 업로드 후 URL
    var profileImageUrl: URL?
    
    /// 회원 종류
    var memberType: MemberType?
    
    /// 경험 종류 (삭제 필요)
    // TODO: 삭제 필요
    var photoCareerType: CareerType?
    
    /// 경험 기간 - 연도
    // TODO: 삭제 필요
    var photoCareerYears: Int?
    
    /// 경험 기간 - 개월 수 (삭제 필요)
    // TODO: 삭제 필요
    var photoCareerMonths: Int?
    
    /// 자신 있는 분위기
    var photoSpecializedThemes: [String]?
    
    var description: String {
        "SignUpSession: nickname: \(nickname) "
        + "/ profileImageUrl: \(String(describing: profileImageUrl)) "
        + "/ memberType: \(String(describing: memberType)) "
        + "/ photoCareerType: \(String(describing: photoCareerType)) "
        + "/ photoCareerYears: \(String(describing: photoCareerYears)) "
        + "/ photoCareerMonths: \(String(describing: photoCareerMonths)) "
        + "/ photoSpecializedThemes: \(String(describing: photoSpecializedThemes))"
    }
    
    enum MemberType {
        case customer
        case photographer
    }
    
    // TODO: 삭제 필요
    enum CareerType {
        case major // 사진 전공
        case job // 수익 창출
        case influencer // SNS 계정 운영
    }
}
