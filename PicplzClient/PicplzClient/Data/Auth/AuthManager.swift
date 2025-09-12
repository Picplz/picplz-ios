//
//  AuthManager.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation
import OSLog

final class AuthManager: AuthManaging {
    // MARK: Dependencies
    private let keychainStore: KeychainStore
    private let userDefaultHelper: UserDefaultsHelper

    // MARK: Properties
    private var tokens: Tokens?
    private(set) var currentUser: AuthUser?

    private var log = Logger.of("AuthManager")

    init(keychainStore: KeychainStore, userDefaultHelper: UserDefaultsHelper) {
        self.keychainStore = keychainStore
        self.userDefaultHelper = userDefaultHelper
        loadFromDeviceStore()
    }

    var accessToken: String? {
        guard let tokens = tokens else { return nil }

        _ = validateToken()

        return tokens.accessToken
    }

    var refreshToken: String? {
        guard let tokens = tokens else { return nil }

        _ = validateToken()

        return tokens.refreshToken
    }

    var isLogin: Bool {
        tokens != nil && currentUser != nil
    }

    /// 소셜 계정 정보를 업데이트 한다. 로그인 완료 전에도 호출될 수 있다.
    /// 소셜 로그인은 했지만, 가입이 완료되지 않은 유저의 경우 로그인되지 않았으나 소셜로그인 정보가 되어있는 상태가 있을 수 있다.
    func updateSocialInfo(email: String, code: String, provider: SocialProvider) {
        let user = self.currentUser
            ?? AuthUser( // Fallback...
                sub: 0,
                nickname: "",
                profileImageUrl: "",
                memberType: nil,
                socialEmail: "",
                socialCode: "",
                socialProvider: .kakao
            )

        self.currentUser = AuthUser( // 복제 후 업데이트한다
            sub: user.sub,
            nickname: user.nickname,
            profileImageUrl: user.profileImageUrl,
            memberType: user.memberType,
            socialEmail: email,
            socialCode: code,
            socialProvider: provider
        )
    }

    func login(tokens: Tokens, userInfo: AuthUser) {
        self.tokens = tokens
        self.currentUser = userInfo
        setToDeviceStore()

        log.debug("AuthManager login... tokens=\(String(describing: self.tokens)) currentUser=\(String(describing: self.currentUser))")
    }

    func logout() {
        log.debug("AuthManager logout...")
        reset()
    }

    private func reset() {
        log.debug("AuthManager reset...")
        tokens = nil
        currentUser = nil
        setToDeviceStore()
    }

    func validateToken() -> Bool {
        guard let expiresDate = tokens?.expiresDate else { return false }

        if Date() > expiresDate {
            log.warning("Token expired... currentDate=\(Date()) expiredDate=\(expiresDate)")
            reset()
            return false
        }

        return true
    }

    func updateUserInfo(user currentUserEntity: AuthUser) {
        self.currentUser = currentUserEntity
        setToDeviceStore()

        log.debug("AuthManager updateUserInfo... currentUser=\(String(describing: self.currentUser))")
    }

    private func setToDeviceStore() {
        // MARK: save currentUser
        if let currentUser = currentUser {
            userDefaultHelper.save(value: currentUser, key: .authUser)
            log.debug("saved currentUser to UserDefaults... value=\(String(describing: currentUser))")
        } else {
            userDefaultHelper.delete(for: .authUser)
            log.debug("deleted currentUser from UserDefaults...")
        }

        // MARK: save tokens
        if let tokens = tokens {
            userDefaultHelper.save(value: tokens.expiresDate, key: .accessTokenExpiresAt)
            log.debug("saved tokens.expiresDate to UserDefaults... value=\(String(describing: tokens.expiresDate))")

            do {
                try keychainStore.saveValue(tokens.accessToken, for: KeychainStore.ReservedAccount.accessToken.rawValue)
                try keychainStore.saveValue(tokens.refreshToken, for: KeychainStore.ReservedAccount.accessToken.rawValue)
                log.debug("saved tokens.token to keychain...")
            } catch {
                log.error("failed to save tokens.token to keychain... error: \(error)")
            }
        } else {
            userDefaultHelper.delete(for: .accessTokenExpiresAt)
            log.debug("deleted tokens.expiresDate from UserDefaults...")

            do {
                try keychainStore.remove(for: KeychainStore.ReservedAccount.accessToken.rawValue)
                try keychainStore.remove(for: KeychainStore.ReservedAccount.refreshToken.rawValue)
                log.debug("deleted tokens.token from keychain...")
            } catch {
                log.error("failed to delete tokens.token from keychain... error: \(error)")
            }
        }
    }

    private func loadFromDeviceStore() {
        // MARK: load currentUser
        currentUser = userDefaultHelper.load(for: .authUser)
        log.debug("loaded currentUser from UserDefaults...")

        // MARK: load tokens
        var accessToken: String?
        var refreshToken: String?
        do {
            try accessToken = keychainStore.loadValue(for: KeychainStore.ReservedAccount.accessToken.rawValue)
            try refreshToken = keychainStore.loadValue(for: KeychainStore.ReservedAccount.refreshToken.rawValue)
        } catch {
            log.error("failed to load tokens.token from keychain... error: \(error)")
        }
        let expiresDate: Date? = userDefaultHelper.load(for: .accessTokenExpiresAt)

        guard let expiresDate = expiresDate,
              let accessToken = accessToken,
              let refreshToken = refreshToken else { return }

        tokens = Tokens(accessToken: accessToken, refreshToken: refreshToken, expiresDate: expiresDate)
        log.debug("loaded tokens.token from keychain...")
    }
}
