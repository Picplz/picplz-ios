//
//  SignInUseCase.swift
//  Domain
//
//  Created by 임영택 on 2/26/26.
//

import Foundation
import Dependencies

public struct SignInUseCase {
  public var execute: (_ kakaoAccessToken: KakaoAccessToken) async throws -> SignInResult
}

enum SignInUseCaseKey: DependencyKey {
  static var liveValue: SignInUseCase {
    @Dependency(\.authRepository) var authRepository
    @Dependency(\.tokenStorage) var tokenStorage
    
    return SignInUseCase { kakaoAccessToken in
      let result = try await authRepository.signIn(kakaoAccessToken: kakaoAccessToken)
      
      if let tokens = result.tokens {
        try tokenStorage.saveAccessToken(tokens.accessToken)
        try tokenStorage.saveRefreshToken(tokens.refreshToken)
      }

      return result
    }
  }
}

public extension DependencyValues {
  var signInUseCase: SignInUseCase {
    get { self[SignInUseCaseKey.self] }
    set { self[SignInUseCaseKey.self] = newValue }
  }
}
