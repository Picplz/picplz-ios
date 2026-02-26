//
//  AuthRepository.swift
//  Networking
//
//  Created by 임영택 on 2/27/26.
//

import Domain
import Moya
import Dependencies

public final class AuthRepository: AuthRepositoryProtocol {
  private let provider: MoyaProvider<PicplzAuthApi>
  
  public init(provider: MoyaProvider<PicplzAuthApi> = .init()) {
    self.provider = provider
  }

  public func signIn(kakaoAccessToken: KakaoAccessToken) async throws -> SignInResult {
    let dto = SignInDTO(accessToken: kakaoAccessToken)
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.signInKakao(dto)) { result in
        switch result {
        case let .success(response):
          do {
            let dto = try response.map(BaseResponseDTO<SignInResponseDTO>.self, using: .customDateDecoder)
            
            guard dto.data.registered,
                  let token = dto.data.token else {
              continuation.resume(returning: SignInResult(tokens: nil, isRegistered: false))
              return
            }
            
            continuation.resume(
              returning: SignInResult(
                tokens: PicplzTokens(
                  accessToken: token.accessToken,
                  refreshToken: token.refreshToken
                ),
                isRegistered: true
              )
            )
          } catch {
            continuation.resume(throwing: error)
          }
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
