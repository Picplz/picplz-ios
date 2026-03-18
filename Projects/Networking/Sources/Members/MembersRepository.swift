//
//  AuthRepository.swift
//  Networking
//
//  Created by 임영택 on 2/27/26.
//

import Dependencies
import Domain
import Moya

public final class MembersRepository: MembersRepositoryProtocol {
  private let provider: MoyaProvider<PicplzMembersApi>

  public init(
    tokenStorage: TokenStorageProtocol,
    onLogout: @escaping () -> Void = {}
  ) {
    self.provider = MoyaProviderFactory.makeAuthorizedProvider(
      for: PicplzMembersApi.self,
      tokenStorage: tokenStorage,
      interceptor: TokenRefreshInterceptor(
        tokenStorage: tokenStorage,
        onLogout: onLogout
      )
    )
  }

  public func checkAllowable(nickname: String) async throws
    -> IsAllowableNickname
  {
    do {
      _ = try await provider.requestAsync(.checkDuplicatedNickname(nickname))
      return true
    } catch {
      if let httpError = error as? HTTPError, case .BadRequest = httpError {
        return false
      }
      throw error
    }
  }

  public func getInfo(memberId: Int) async throws -> MemberInfo? {
    let dto: MemberInfoResponseDTO = try await provider.requestWithDTO(.getMemberInfo(memberId))

    return MemberInfo(
      id: dto.id,
      role: .from(rawValue: dto.role) ?? .customer,
      nickname: dto.nickname,
      socialInfo: SocialInfo(
        socialEmail: dto.socialEmail,
        socialProvider: .from(rawValue: dto.socialCode) ?? .kakao,
        socialCode: dto.socialCode
      ),
      profileImage: dto.profileImage
    )
  }
  
  public func createCustomer(request: Domain.RegisterRequest) async throws {
    let dto = CreateCustomerRequestDTO(
      nickname: request.nickname,
      socialEmail: request.socialInfo.socialEmail,
      socialProvider: request.socialInfo.socialProvider.rawValue,
      socialCode: request.socialInfo.socialCode,
      profileImage: request.profileImage ?? ""
    )
    
    _ = try await provider.requestAsync(.createCustomer(dto))
  }

  public func createPhotographer(request: Domain.RegisterRequest, extra: Domain.PhotographerRegisterRequestExtra) async throws {
    let activeAreas = extra.activeAreas.enumerated().map { index, area in
      ActiveAreaDTO(code: area.id, priority: index)
    }
    
    let cameras = extra.cameras.map { equipment in
      let type: String
      let cameraType: String
      
      switch equipment.type {
      case .phone:
        type = "핸드폰"
        cameraType = ""
      case .camera(let cType):
        type = "카메라"
        switch cType {
        case .dslrCamera: cameraType = "DSLR 카메라"
        case .mirrorlessCamera: cameraType = "미러리스 카메라"
        case .campactCamera: cameraType = "디지털 카메라"
        case .filmCamera: cameraType = "필름 카메라"
        case .unknown: cameraType = "UNKNOWN"
        }
      case .unknown:
        type = "기타"
        cameraType = ""
      }
      
      return CameraDTO(
        type: type,
        brand: equipment.brand,
        name: equipment.name ?? "",
        cameraType: cameraType
      )
    }
    
    let dto = CreatePhotographerRequestDTO(
      nickname: request.nickname,
      socialEmail: request.socialInfo.socialEmail,
      socialProvider: request.socialInfo.socialProvider.rawValue,
      socialCode: request.socialInfo.socialCode,
      profileImage: request.profileImage ?? "",
      photoMoods: extra.photoMoods,
      activeAreas: activeAreas,
      cameras: cameras
    )
    
    _ = try await provider.requestAsync(.createPhotographer(dto))
  }
}
