//
//  AuthPlugin.swift
//  Networking
//
//  Created by 임영택 on 3/10/26.
//

import Domain
import Foundation
import Moya

public final class AuthPlugin: PluginType {
  private let tokenStorage: TokenStorageProtocol
  private let interceptor: TokenRefreshInterceptorProtocol

  public init(
    tokenStorage: TokenStorageProtocol,
    interceptor: TokenRefreshInterceptorProtocol
  ) {
    self.tokenStorage = tokenStorage
    self.interceptor = interceptor
  }

  public func process(
    _ result: Result<Response, MoyaError>,
    target: any TargetType
  ) -> Result<Response, MoyaError> {
    guard case .success(let response) = result, response.statusCode == 401
    else {
      return result
    }
    return refreshAndRetry(target: target)
  }

  private func refreshAndRetry(target: any TargetType) -> Result<
    Response, MoyaError
  > {
    var refreshedResult: Result<Response, MoyaError> = .failure(
      .underlying(
        NSError(
          domain: "AuthPlugin",
          code: -1,
          userInfo: [NSLocalizedDescriptionKey: "Token refresh failed"]
        ),
        nil
      )
    )

    let group = DispatchGroup()
    group.enter()

    interceptor.refresh { [weak self] refreshResult in
      guard let self else {
        group.leave()
        return
      }

      switch refreshResult {
      case .success(let newToken):
        do {
          try self.tokenStorage.saveAccessToken(newToken)
          refreshedResult = self.retry(target: target)
        } catch {
          refreshedResult = .failure(.underlying(error, nil))
        }
      case .failure(let error):
        refreshedResult = .failure(.underlying(error, nil))
      }
      group.leave()
    }

    group.wait()
    return refreshedResult
  }

  private func retry(target: any TargetType) -> Result<Response, MoyaError> {
    var retryResult: Result<Response, MoyaError> = .failure(
      .underlying(
        NSError(domain: "AuthPlugin", code: -1),
        nil
      )
    )

    let group = DispatchGroup()
    group.enter()

    let provider = MoyaProvider<MultiTarget>(plugins: [
      AccessTokenPlugin { _ in self.tokenStorage.getAccessToken() ?? "" }
    ])

    provider.request(MultiTarget(target)) { result in
      retryResult = result
      group.leave()
    }

    group.wait()
    return retryResult
  }
}
