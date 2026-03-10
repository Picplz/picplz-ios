//
//  MemberInfo.swift
//  Domain
//
//  Created by 임영택 on 3/10/26.
//

import Foundation

public struct MemberInfo: Equatable {
  public let id: Int
  public let role: Role
  public let nickname: String
  public let socialInfo: SocialInfo
  public let profileImage: S3ObjectKey?
  
  public init(id: Int, role: Role, nickname: String, socialInfo: SocialInfo, profileImage: S3ObjectKey?) {
    self.id = id
    self.role = role
    self.nickname = nickname
    self.socialInfo = socialInfo
    self.profileImage = profileImage
  }
}
