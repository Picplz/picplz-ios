//
//  GetTokensUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/2/26.
//

import Foundation
import Dependencies

public struct GetTokensUseCase {
  public var execute: () -> PicplzTokens?
}

enum GetTokensUseCaseKey: DependencyKey {
  static var liveValue: GetTokensUseCase {
    @Dependency(\.tokenStorage) var tokenStorage
    
    return GetTokensUseCase {
      let accessToken = tokenStorage.getAccessToken()
      let refreshToken = tokenStorage.getRefreshToken()
      
      guard let accessToken, let refreshToken else {
        return nil
      }
      return PicplzTokens(accessToken: accessToken, refreshToken: refreshToken)
    }
  }
}

public extension DependencyValues {
  var getTokensUseCase: GetTokensUseCase {
    get { self[GetTokensUseCaseKey.self] }
    set { self[GetTokensUseCaseKey.self] = newValue }
  }
}
