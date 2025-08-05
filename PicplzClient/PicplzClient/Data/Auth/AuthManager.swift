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
    private(set) var socialInfo: SocialInfo?
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
        
        let _ = validateToken()
        
        return tokens.accessToken
    }
    
    var refreshToken: String? {
        guard let tokens = tokens else { return nil }
        
        let _ = validateToken()
        
        return tokens.refreshToken
    }
    
    var isLogin: Bool {
        tokens != nil && socialInfo != nil && currentUser != nil
    }
    
    func updateSocialInfo(socialInfo: SocialInfo) {
        self.socialInfo = socialInfo
    }
    
    func login(tokens: Tokens) {
        self.tokens = tokens
        self.currentUser = AuthUser(sub: 0, name: "", nickname: "", birth: Date(), role: "", kakaoEmail: "", profileImageUrl: "") // FIXME
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
                try keychainStore.saveValue(tokens.accessToken, for: KeychainStore.ReservedAccount.AccessToken.rawValue)
                try keychainStore.saveValue(tokens.refreshToken, for: KeychainStore.ReservedAccount.AccessToken.rawValue)
                log.debug("saved tokens.token to keychain...")
            } catch {
                log.error("failed to save tokens.token to keychain... error: \(error)")
            }
        } else {
            userDefaultHelper.delete(for: .accessTokenExpiresAt)
            log.debug("deleted tokens.expiresDate from UserDefaults...")
            
            do {
                try keychainStore.remove(for: KeychainStore.ReservedAccount.AccessToken.rawValue)
                try keychainStore.remove(for: KeychainStore.ReservedAccount.RefreshToken.rawValue)
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
            try accessToken = keychainStore.loadValue(for: KeychainStore.ReservedAccount.AccessToken.rawValue)
            try refreshToken = keychainStore.loadValue(for: KeychainStore.ReservedAccount.RefreshToken.rawValue)
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
