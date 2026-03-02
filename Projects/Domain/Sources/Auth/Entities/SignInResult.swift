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
  
  public init(tokens: PicplzTokens?, isRegistered: Bool) {
    self.tokens = tokens
    self.isRegistered = isRegistered
  }
}
