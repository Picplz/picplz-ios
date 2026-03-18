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

  public static func live(
    authRepository: any AuthRepositoryProtocol,
    tokenStorage: any TokenStorageProtocol
  ) -> Self {
    Self { kakaoAccessToken in
      let result = try await authRepository.signIn(kakaoAccessToken: kakaoAccessToken)
      
      if let tokens = result.tokens {
        try tokenStorage.saveAccessToken(tokens.accessToken)
        try tokenStorage.saveRefreshToken(tokens.refreshToken)
      }

      return result
    }
  }

  public static var test: Self {
    Self { _ in fatalError("SignInUseCase.test is not implemented") }
  }
}

public enum SignInUseCaseKey: TestDependencyKey {
  public static var testValue: SignInUseCase = .test
}

public extension DependencyValues {
  var signInUseCase: SignInUseCase {
    get { self[SignInUseCaseKey.self] }
    set { self[SignInUseCaseKey.self] = newValue }
  }
}
