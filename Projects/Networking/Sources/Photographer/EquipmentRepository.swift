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
    let dtos: [DefaultEquipmentResponseDTO] = try await provider.requestWithDTO(.getDefaultEquipments)
    return dtos.map { dtoItem in
      dtoItem.toDomain()
    }
  }
}
