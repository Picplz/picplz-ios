//
//  GetTokensUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/2/26.
//

import Dependencies
import Foundation

public struct GetTokensUseCase {
  public var execute: () -> PicplzTokens?

  public static func live(tokenStorage: any TokenStorageProtocol) -> Self {
    Self {
      let accessToken = tokenStorage.getAccessToken()
      let refreshToken = tokenStorage.getRefreshToken()

      guard let accessToken, let refreshToken else {
        return nil
      }
      return PicplzTokens(accessToken: accessToken, refreshToken: refreshToken)
    }
  }

  public static var test: Self {
    Self { nil }
  }
}

public enum GetTokensUseCaseKey: TestDependencyKey {
  public static var testValue: GetTokensUseCase = .test
}

extension DependencyValues {
  public var getTokensUseCase: GetTokensUseCase {
    get { self[GetTokensUseCaseKey.self] }
    set { self[GetTokensUseCaseKey.self] = newValue }
  }
}
