//
//  SignUpSession.swift
//  PicplzClient
//
//  Created by 임영택 on 2/18/25.
//

final class SignUpSession: CustomStringConvertible {
    var nickname: String = ""
    var profileImage: String?
    var memberType: MemberType?
    var photoCareerYears: Int?
    var photoCareerMonths: Int?
    var photoSpecializedThemes: [String]?
    
    var description: String {
        "SignUpSession: nickname: \(nickname) "
        + "/ profileImage: \(String(describing: profileImage)) "
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
