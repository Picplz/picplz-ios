//
//  AreasRepository.swift
//  Networking
//
//  Created by 임영택 on 3/15/26.
//

import Dependencies
import Domain
import Moya

public final class AreasRepository: AreasRepositoryProtocol {
  private let provider: MoyaProvider<PicplzAreasApi>

  public init(
    tokenStorage: TokenStorageProtocol,
    onLogout: @escaping () -> Void = {}
  ) {
    self.provider = MoyaProviderFactory.makeAuthorizedProvider(
      for: PicplzAreasApi.self,
      tokenStorage: tokenStorage,
      interceptor: TokenRefreshInterceptor(
        tokenStorage: tokenStorage,
        onLogout: onLogout
      )
    )
  }

  public func searchAreas(keyword: String) async throws -> [Area] {
    let dtos: [AreaInfoResponseDTO] = try await provider.requestWithDTO(.searchAreas(keyword))
    return dtos.map { dto in
      Area(
        id: dto.id,
        name: dto.name,
        dong: dto.dong,
        ri: dto.ri
      )
    }
  }

  public func getNearbyAreas(radius: Int, latitude: Double, longitude: Double) async throws -> [Area] {
    let dtos: [AreaInfoResponseDTO] = try await provider.requestWithDTO(
      .getNearbyAreas(rad: radius, lat: latitude, lng: longitude)
    )
    return dtos.map { dto in
      Area(
        id: dto.id,
        name: dto.name,
        dong: dto.dong,
        ri: dto.ri
      )
    }
  }
}
