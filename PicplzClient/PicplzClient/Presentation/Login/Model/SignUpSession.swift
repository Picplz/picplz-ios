//
//  SignUpSession.swift
//  PicplzClient
//
//  Created by 임영택 on 2/18/25.
//

import Foundation

final class SignUpSession: CustomStringConvertible {
    var nickname: String = ""
    var profileImageUrl: URL?
    var memberType: MemberType?
    var photoCareerYears: Int?
    var photoCareerMonths: Int?
    var photoSpecializedThemes: [String]?
    
    var description: String {
        "SignUpSession: nickname: \(nickname) "
        + "/ profileImageUrl: \(String(describing: profileImageUrl)) "
        + "/ memberType: \(String(describing: memberType)) "
        + "/ photoCareerYears: \(String(describing: photoCareerYears)) "
        + "/ photoCareerMonths: \(String(describing: photoCareerMonths)) "
        + "/ photoSpecializedThemes: \(String(describing: photoSpecializedThemes))"
    }
    
    enum MemberType {
        case customer
        case photographer
    }
}
