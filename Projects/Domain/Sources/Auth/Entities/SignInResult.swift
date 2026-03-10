//
//  SignInResult.swift
//  Domain
//
//  Created by 임영택 on 2/28/26.
//

import Foundation

public struct SignInResult {
  public let tokens: PicplzTokens?
  public let isRegistered: Bool
  public let socialInfo: SocialInfo
  
  public init(tokens: PicplzTokens?, isRegistered: Bool, socialInfo: SocialInfo) {
    self.tokens = tokens
    self.isRegistered = isRegistered
    self.socialInfo = socialInfo
  }
}
