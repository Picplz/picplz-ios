//
//  AuthManagerTests.swift
//  PicplzClientTests
//
//  Created by 임영택 on 2/11/25.
//

import Testing
import Foundation
@testable import PicplzClient

struct AuthManagerTests {
    let authManager: AuthManager

    let dummyUser: AuthUser = .init(
        sub: 1,
        nickname: "테스트 닉네임",
        profileImageUrl: "http://picplz.com/profile.jpg",
        memberType: .customer,
        socialEmail: "test@kakao.co.kr",
        socialCode: "1234",
        socialProvider: .kakao
    )

    init() {
        authManager = AuthManager(keychainStore: KeychainStore(),
                                  userDefaultHelper: UserDefaultsHelper(userDefaults: UserDefaults())) // UserDefaults 분리
    }

    let dummyDate: Date = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let rawTimestamp = "2025-02-11T15:12:25+0900"
        let convertedDate = dateFormatter.date(from: rawTimestamp)!
        return convertedDate
    }()

    @Test func isLoginShouldBeTrueWhenLogin() async throws {
        authManager.login(
            tokens: .init(
                accessToken: "accessToken",
                refreshToken: "refreshToken",
                expiresDate: Date()
            ),
            userInfo: dummyUser
        )
        #expect(authManager.isLogin == true)
    }

    @Test func isLoginShouldBeFalseWhenNotLogin() async throws {
        #expect(authManager.isLogin == false)
    }

    @Test func whenTokenExpiredShouldResetOnCallingValidateToken() async throws {
        authManager.login(
            tokens: .init(
                accessToken: "accessToken",
                refreshToken: "refreshToken",
                expiresDate: dummyDate
            ),
            userInfo: dummyUser
        )
        #expect(authManager.validateToken() == false)
        #expect(authManager.accessToken == nil)
    }
}
