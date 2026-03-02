//
//  AuthRepository.swift
//  Networking
//
//  Created by 임영택 on 2/27/26.
//

import Domain
import Moya
import Dependencies

public final class MembersRepository: MembersRepositoryProtocol {
  private let provider: MoyaProvider<PicplzMembersApi>
  
  public init(provider: MoyaProvider<PicplzMembersApi> = .init()) {
    self.provider = provider
  }

  public func checkAllowable(nickname: String) async throws -> IsAllowableNickname {
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.checkDuplicatedNickname(nickname)) { result in
        switch result {
        case .success:
          continuation.resume(returning: true)
        case let .failure(error):
          if error.response?.statusCode == 400 {
            continuation.resume(returning: false)
          }
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
