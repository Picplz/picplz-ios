//
//  KakaoAccessToken.swift
//  Domain
//
//  Created by 임영택 on 2/27/26.
//

import Foundation

public typealias KakaoAccessToken = String
public typealias PicplzAuthToken = String

public struct PicplzTokens {
  let accessToken: PicplzAuthToken
  let refreshToken: PicplzAuthToken
  
  public init(accessToken: PicplzAuthToken, refreshToken: PicplzAuthToken) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }
}
