//
//  TokenRefreshInterceptor.swift
//  Networking
//
//  Created by 임영택 on 3/10/26.
//

import Domain
import Moya
import Foundation

public final class TokenRefreshInterceptor: TokenRefreshInterceptorProtocol {
  private let tokenStorage: TokenStorageProtocol
  private let provider: MoyaProvider<PicplzAuthApi>
  private let onLogout: () -> Void

  public init(
    tokenStorage: TokenStorageProtocol,
    onLogout: @escaping () -> Void
  ) {
    self.tokenStorage = tokenStorage
    self.onLogout = onLogout
    self.provider = MoyaProvider<PicplzAuthApi>()
  }

  public func refresh(
    completion: @escaping (Result<PicplzAuthToken, Error>) -> Void
  ) {
    guard let refreshToken = tokenStorage.getRefreshToken() else {
      onLogout()
      completion(.failure(TokenRefreshError.noRefreshToken))
      return
    }

//    provider.request(.refresh(refreshToken: refreshToken)) { result in
//      switch result {
//      case .success(let response):
//        do {
//          let dto = try response.map(BaseResponseDTO<TokenResponseDTO>.self)
//          completion(.success(dto.data.accessToken))
//        } catch {
//          completion(.failure(error))
//        }
//      case .failure(let error):
//        self.onLogout()
//        completion(.failure(error))
//      }
//    }
    completion(.failure(TokenRefreshError.notImplementedOnServer)) // TODO: 토큰 리프레시 인터페이스 나오면 통합
  }
}

enum TokenRefreshError: LocalizedError {
  case noRefreshToken
  case notImplementedOnServer
  
  var errorDescription: String? {
    switch self {
    case .noRefreshToken: "리프레시 토큰이 없습니다"
    case .notImplementedOnServer: "리프레시 인터페이스가 공개되지 않음"
    }
  }
}
