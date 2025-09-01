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
        // MARK: 카카오 로그인 결과 처리
        guard let accessToken = accessToken,
              let _ = refreshToken else {
            log.error("accessToken is nil.")
            throw DomainError.venderError("카카오 로그인 시 오류가 발생했습니다.")
        }
        
        guard let result = try await authRequests.kakaoLogin(kakaoAccessToken: accessToken) else {
            throw DomainError.serverError("서버 오류가 발생했습니다")
        }
        
        let loginResponse = result.data
        
        // MARK: 픽플즈 서버로부터 전달받은 유저 인증 정보를 로컬에 저장
        guard let email = loginResponse.socialEmail else {
            throw DomainError.validationError("소셜 아메일이 제공되지 않았습니다.")
        }
        
        guard let socialProvider = SocialProvider(rawValue: loginResponse.socialProvider) else {
            throw DomainError.validationError("소셜 아이디 제공자가 잘못되었습니다.")
        }
        
        authManaging.updateSocialInfo(email: email, code: loginResponse.socialCode, provider: socialProvider)
        
        guard let tokenResponse = loginResponse.token,
              loginResponse.registered else {
            throw DomainError.notRegisteredUser // 가입되지 않은 계정이면 회원가입 코디네이터 시작
        }
        
        // 추가적인 유저 정보를 픽플즈 서버에서 불러옴
        let token = Tokens(
            accessToken: tokenResponse.accessToken,
            refreshToken: tokenResponse.refreshToken,
            expiresDate: tokenResponse.accessTokenExpiresDate
        )
        guard let accessTokenPayload = token.accessTokenPayload else {
            throw DomainError.validationError("Access Token에서 Payload를 추출하지 못했습니다.")
        }
        
        do {
            if let userInfoResponse = try await authRequests.getUserInfo(accessToken: token.accessToken, memberId: accessTokenPayload.sub) {
                let userInfo = userInfoResponse.data
                
                authManaging.login(
                    tokens: Tokens(
                        accessToken: token.accessToken,
                        refreshToken: token.refreshToken,
                        expiresDate: token.expiresDate
                    ),
                    userInfo: AuthUser(
                        sub: userInfo.id,
                        nickname: userInfo.nickname,
                        profileImageUrl: userInfo.profileImage,
                        memberType: .init(rawValue: userInfo.role) ?? .customer,
                        socialEmail: userInfo.socialEmail,
                        socialCode: userInfo.socialCode,
                        socialProvider: .init(rawValue: userInfo.socialProvider) ?? .kakao
                    )
                )
            }
        } catch {
            throw DomainError.serverError("유저 정보를 얻는데 실패했습니다. \(error)")
        }
    }
}
