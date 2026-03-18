//
//  MoyaProviderFactory.swift
//  Networking
//
//  Created by 임영택 on 3/10/26.
//

import Domain
import Moya

public enum MoyaProviderFactory {
  public static func makeAuthorizedProvider<
    T: TargetType & AccessTokenAuthorizable
  >(
    for type: T.Type,
    tokenStorage: TokenStorageProtocol,
    interceptor: TokenRefreshInterceptorProtocol
  ) -> MoyaProvider<T> {
    let authPlugin = AuthPlugin(
      tokenStorage: tokenStorage,
      interceptor: interceptor
    )
    return MoyaProvider<T>(plugins: [
      AccessTokenPlugin { _ in tokenStorage.getAccessToken() ?? "" },
      authPlugin,
    ])
  }
}
