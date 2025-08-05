//
//  LoginUseCase.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation
import KakaoSDKUser
import os.log

protocol LoginUseCase {
    func login() async throws
}

final class LoginUseCaseImpl: LoginUseCase {
    let authManaging: AuthManaging
    let authRequests: AuthRequestable
    private let log = Logger.of("LoginUseCaseImpl")
    
    init(authManaging: AuthManaging, authRequests: AuthRequestable) {
        self.authManaging = authManaging
        self.authRequests = authRequests
    }
    
    func login() async throws {
        let (accessToken, refreshToken): (String?, String?) = try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    let log = Logger.of("LoginUseCaseImplCallback")
                    
                    if let error = error {
                        log.error("loginWithKakaoTalk failed. \(error)")
                        continuation.resume(throwing: error) // TODO: custom error
                    } else {
                        continuation.resume(returning: (oauthToken?.accessToken, oauthToken?.refreshToken))
                    }
                }
                
                return
            }
            
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                let log = Logger.of("LoginUseCaseImplCallback")
                
                if let error = error {
                    log.error("loginWithKakaoAccount failed. \(error)")
                    continuation.resume(throwing: error) // TODO: custom error
                } else {
                    continuation.resume(returning: (oauthToken?.accessToken, oauthToken?.refreshToken))
                }
            }
        }
        
        try await handleLoginSuccess(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    private func handleLoginSuccess(accessToken: String?, refreshToken: String?) async throws {
        guard let accessToken = accessToken,
              let _ = refreshToken else {
            log.error("accessToken is nil.")
            throw DomainError.venderError("카카오 로그인 시 오류가 발생했습니다.")
        }
        
        guard let result = try await authRequests.kakaoLogin(kakaoAccessToken: accessToken) else {
            throw DomainError.serverError("서버 오류가 발생했습니다")
        }
        
        let loginResponse = result.data
        authManaging.updateSocialInfo(
            socialInfo: SocialInfo(
                nickname: nil,
                socialEmail: loginResponse.socialEmail ?? "",
                socialCode: loginResponse.socialCode,
                socialProvider: SocialProvider(rawValue: loginResponse.socialCode) ?? .kakao
            )
        )
        
        guard let token = loginResponse.token,
              loginResponse.registered else {
            throw DomainError.notRegisteredUser // 토큰이 존재하지 않으면 회원가입 코디네이터 시작
        }
        
        authManaging.login(tokens: Tokens(
            accessToken: token.accessToken,
            refreshToken: token.refreshToken,
            expiresDate: token.accessTokenExpiresDate
        ))
    }
}
