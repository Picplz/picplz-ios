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
            do {
              try HTTPError.checkError(response: response)
            } catch {
              continuation.resume(throwing: error)
            }
            
            let dto = try response.map(BaseResponseDTO<SignInResponseDTO>.self, using: .customDateDecoder)

            var tokens: PicplzTokens? = nil
            if let rawTokenInfo = dto.data.token {
              tokens = PicplzTokens(
                accessToken: rawTokenInfo.accessToken,
                refreshToken: rawTokenInfo.refreshToken
              )
            }
            
            continuation.resume(
              returning: SignInResult(
                tokens: tokens,
                isRegistered: dto.data.registered,
                socialInfo: SocialInfo(
                  socialEmail: dto.data.socialEmail ?? "",
                  socialProvider: .from(rawValue: dto.data.socialProvider) ?? .kakao,
                  socialCode: dto.data.socialCode
                )
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
