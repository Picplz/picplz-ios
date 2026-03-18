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
    let responseDTO: SignInResponseDTO = try await provider.requestWithDTO(.signInKakao(dto))
    
    var tokens: PicplzTokens? = nil
    if let rawTokenInfo = responseDTO.token {
      tokens = PicplzTokens(
        accessToken: rawTokenInfo.accessToken,
        refreshToken: rawTokenInfo.refreshToken
      )
    }
    
    return SignInResult(
      tokens: tokens,
      isRegistered: responseDTO.registered,
      socialInfo: SocialInfo(
        socialEmail: responseDTO.socialEmail ?? "",
        socialProvider: .from(rawValue: responseDTO.socialProvider) ?? .kakao,
        socialCode: responseDTO.socialCode
      )
    )
  }
}
