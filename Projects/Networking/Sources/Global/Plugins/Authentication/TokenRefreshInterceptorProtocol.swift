//
//  TokenRefreshInterceptorProtocol.swift
//  Networking
//
//  Created by 임영택 on 3/10/26.
//

import Domain

public protocol TokenRefreshInterceptorProtocol {
  func refresh(completion: @escaping (Result<PicplzAuthToken, Error>) -> Void)
}
