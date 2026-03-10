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
}
