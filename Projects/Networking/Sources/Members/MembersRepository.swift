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
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.checkDuplicatedNickname(nickname)) { result in
        switch result {
        case .success(let response):
          if response.statusCode == 400 {
            continuation.resume(returning: false)
            return
          }
          
          do {
            try HTTPError.checkError(response: response)
          } catch {
            continuation.resume(throwing: error)
          }
          
          continuation.resume(returning: true)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }

  public func getInfo(memberId: Int) async throws -> MemberInfo? {
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getMemberInfo(memberId)) { result in
        switch result {
        case .success(let response):
          do {
            try HTTPError.checkError(response: response)
          } catch {
            continuation.resume(throwing: error)
          }
          
          let dto: BaseResponseDTO<MemberInfoResponseDTO>
          do {
            dto = try response.map(
              BaseResponseDTO<MemberInfoResponseDTO>.self,
              using: .customDateDecoder
            )
          } catch {
            continuation.resume(throwing: error)
            return
          }

          continuation.resume(
            returning: MemberInfo(
              id: dto.data.id,
              role: .from(rawValue: dto.data.role) ?? .customer,
              nickname: dto.data.nickname,
              socialInfo: SocialInfo(
                socialEmail: dto.data.socialEmail,
                socialProvider: .from(rawValue: dto.data.socialCode) ?? .kakao,
                socialCode: dto.data.socialCode
              ),
              profileImage: dto.data.profileImage
            )
          )
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  public func createCustomer(request: Domain.RegisterRequest) async throws {
    let dto = CreateCustomerRequestDTO(
      nickname: request.nickname,
      socialEmail: request.socialInfo.socialEmail,
      socialProvider: request.socialInfo.socialProvider.rawValue,
      socialCode: request.socialInfo.socialCode,
      profileImage: request.profileImage ?? ""
    )
    
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.createCustomer(dto)) { result in
        switch result {
        case .success(let response):
          do {
            try HTTPError.checkError(response: response)
          } catch {
            continuation.resume(throwing: error)
            return
          }
          
          continuation.resume()
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
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
    
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.createPhotographer(dto)) { result in
        switch result {
        case .success(let response):
          do {
            try HTTPError.checkError(response: response)
          } catch {
            continuation.resume(throwing: error)
            return
          }
          
          continuation.resume()
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
