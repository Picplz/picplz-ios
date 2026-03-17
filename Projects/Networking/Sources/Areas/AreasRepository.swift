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
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.searchAreas(keyword)) { result in
        switch result {
        case .success(let response):
          do {
            try HTTPError.checkError(response: response)
            let dto = try response.map(BaseResponseDTO<[AreaInfoResponseDTO]>.self, using: .customDateDecoder)
            
            let domainEntities = dto.data.map { dto in
              Area(
                id: dto.id,
                name: dto.name,
                dong: dto.dong,
                ri: dto.ri
              )
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

  public func getNearbyAreas(radius: Int, latitude: Double, longitude: Double) async throws -> [Area] {
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getNearbyAreas(rad: radius, lat: latitude, lng: longitude)) { result in
        switch result {
        case .success(let response):
          do {
            try HTTPError.checkError(response: response)
            let dto = try response.map(BaseResponseDTO<[AreaInfoResponseDTO]>.self, using: .customDateDecoder)
            let domainEntities = dto.data.map { dto in
              Area(
                id: dto.id,
                name: dto.name,
                dong: dto.dong,
                ri: dto.ri
              )
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
