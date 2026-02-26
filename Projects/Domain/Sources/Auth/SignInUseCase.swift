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
    return SignInUseCase { kakaoAccessToken in
      return try await authRepository.signIn(kakaoAccessToken: kakaoAccessToken)
    }
  }
}

public extension DependencyValues {
  var signInUseCase: SignInUseCase {
    get { self[SignInUseCaseKey.self] }
    set { self[SignInUseCaseKey.self] = newValue }
  }
}
