//
//  RegisterRequest.swift
//  Domain
//
//  Created by 임영택 on 3/9/26.
//

import Foundation

public struct RegisterRequest: Equatable {
  public var nickname: String
  public let socialInfo: SocialInfo
  public var profileImage: S3ObjectKey?
  
  public init(nickname: String, socialInfo: SocialInfo, profileImage: S3ObjectKey?) {
    self.nickname = nickname
    self.socialInfo = socialInfo
    self.profileImage = profileImage
  }
}
