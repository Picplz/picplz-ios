//
//  SocialInfo.swift
//  Domain
//
//  Created by 임영택 on 3/10/26.
//

import Foundation

public struct SocialInfo: Equatable, Hashable {
  public let socialEmail: String
  public let socialProvider: SignInProvider
  public let socialCode: String
  
  public init(socialEmail: String, socialProvider: SignInProvider, socialCode: String) {
    self.socialEmail = socialEmail
    self.socialProvider = socialProvider
    self.socialCode = socialCode
  }
}
