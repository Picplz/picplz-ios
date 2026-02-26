//
//  AuthRepositoryProtocol.swift
//  Domain
//
//  Created by 임영택 on 2/27/26.
//

import Dependencies

public protocol AuthRepositoryProtocol {
  func signIn(kakaoAccessToken: KakaoAccessToken) async throws -> SignInResult
}

struct UnimplementedAuthRepository: AuthRepositoryProtocol {
  func signIn(kakaoAccessToken: KakaoAccessToken) async throws -> SignInResult {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
}

public enum AuthRepositoryKey: DependencyKey {
  public static var liveValue: AuthRepositoryProtocol = UnimplementedAuthRepository()
}

public extension DependencyValues {
  var authRepository: AuthRepositoryProtocol {
    get { self[AuthRepositoryKey.self] }
    set { self[AuthRepositoryKey.self] = newValue }
  }
}
