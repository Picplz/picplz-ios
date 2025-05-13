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
    private var tokenModel: Token?
    private(set) var currentUser: AuthUser?
    
    private var log = Logger.of("AuthManager")
    
    init(keychainStore: KeychainStore, userDefaultHelper: UserDefaultsHelper) {
        self.keychainStore = keychainStore
        self.userDefaultHelper = userDefaultHelper
        loadFromDeviceStore()
    }
    
    var accessToken: String? {
        guard let tokenModel = tokenModel else { return nil }
        
        let _ = validateToken()
        
        return tokenModel.accessToken
    }
    
    var isLogin: Bool {
        tokenModel != nil && currentUser != nil
    }
    
    func login(accessToken: String, refreshToken: String, expiresDate: Date) {
        self.tokenModel = Token(accessToken: accessToken, refreshToken: refreshToken, expiresDate: expiresDate)
        self.currentUser = AuthUser(sub: 0, name: "", nickname: "", birth: Date(), role: "", kakaoEmail: "", profileImageUrl: "") // FIXME
        setToDeviceStore()
        
        log.debug("AuthManager login... token=\(String(describing: self.tokenModel)) currentUser=\(String(describing: self.currentUser))")
    }
    
    func logout() {
        log.debug("AuthManager logout...")
        reset()
    }
    
    private func reset() {
        log.debug("AuthManager reset...")
        tokenModel = nil
        currentUser = nil
        setToDeviceStore()
    }
    
    func validateToken() -> Bool {
        guard let expiresDate = tokenModel?.expiresDate else { return false }
        
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
        
        // MARK: save tokenModel
        if let tokenModel = tokenModel {
            userDefaultHelper.save(value: tokenModel.expiresDate, key: .accessTokenExpiresAt)
            log.debug("saved tokenModel.expiresDate to UserDefaults... value=\(String(describing: tokenModel.expiresDate))")
            
            do {
                try keychainStore.saveValue(tokenModel.accessToken, for: KeychainStore.ReservedAccount.AccessToken.rawValue)
                try keychainStore.saveValue(tokenModel.refreshToken, for: KeychainStore.ReservedAccount.AccessToken.rawValue)
                log.debug("saved tokenModel.token to keychain...")
            } catch {
                log.error("failed to save tokenModel.token to keychain... error: \(error)")
            }
        } else {
            userDefaultHelper.delete(for: .accessTokenExpiresAt)
            log.debug("deleted tokenModel.expiresDate from UserDefaults...")
            
            do {
                try keychainStore.remove(for: KeychainStore.ReservedAccount.AccessToken.rawValue)
                try keychainStore.remove(for: KeychainStore.ReservedAccount.RefreshToken.rawValue)
                log.debug("deleted tokenModel.token from keychain...")
            } catch {
                log.error("failed to delete tokenModel.token from keychain... error: \(error)")
            }
        }
    }
    
    private func loadFromDeviceStore() {
        // MARK: load currentUser
        currentUser = userDefaultHelper.load(for: .authUser)
        log.debug("loaded currentUser from UserDefaults...")
        
        // MARK: load tokenModel
        var accessToken: String?
        var refreshToken: String?
        do {
            try accessToken = keychainStore.loadValue(for: KeychainStore.ReservedAccount.AccessToken.rawValue)
            try refreshToken = keychainStore.loadValue(for: KeychainStore.ReservedAccount.RefreshToken.rawValue)
        } catch {
            log.error("failed to load tokenModel.token from keychain... error: \(error)")
        }
        let expiresDate: Date? = userDefaultHelper.load(for: .accessTokenExpiresAt)
        
        guard let expiresDate = expiresDate,
              let accessToken = accessToken,
              let refreshToken = refreshToken else { return }
        
        tokenModel = Token(accessToken: accessToken, refreshToken: refreshToken, expiresDate: expiresDate)
        log.debug("loaded tokenModel.token from keychain...")
    }
}
