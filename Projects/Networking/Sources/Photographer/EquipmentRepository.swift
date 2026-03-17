//
//  EquipmentRepository.swift
//  Networking
//
//  Created by 임영택 on 3/17/26.
//

import Dependencies
import Domain
import Moya

public final class EquipmentRepository: EquipmentRepositoryProtocol {
  private let provider: MoyaProvider<PicplzPhotographerEquipmentApi>

  public init(
    tokenStorage: TokenStorageProtocol,
    onLogout: @escaping () -> Void = {}
  ) {
    self.provider = MoyaProviderFactory.makeAuthorizedProvider(
      for: PicplzPhotographerEquipmentApi.self,
      tokenStorage: tokenStorage,
      interceptor: TokenRefreshInterceptor(
        tokenStorage: tokenStorage,
        onLogout: onLogout
      )
    )
  }

  public func getDefaultEquipments() async throws -> [PhotographerEquipment] {
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getDefaultEquipments) { result in
        switch result {
        case .success(let response):
          do {
            try HTTPError.checkError(response: response)
            let dto = try response.map(BaseResponseDTO<[DefaultEquipmentResponseDTO]>.self, using: .customDateDecoder)
            
            let domainEntities = dto.data.map { dtoItem in
              dtoItem.toDomain()
            }
            continuation.resume(returning: domainEntities)
          } catch {
            continuation.resume(throwing: error)
          }
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
