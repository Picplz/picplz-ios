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
    private var accessTokenModel: AccessToken?
    private var currentUserModel: AuthUserModel?
    
    private var log = Logger.of("AuthManager")
    
    init(keychainStore: KeychainStore, userDefaultHelper: UserDefaultsHelper) {
        self.keychainStore = keychainStore
        self.userDefaultHelper = userDefaultHelper
        loadFromDeviceStore()
    }
    
    var accessToken: String? {
        guard let accessTokenModel = accessTokenModel else { return nil }
        
        let _ = validateToken()
        
        return accessTokenModel.token
    }
    
    var currentUser: AuthUser? {
        currentUserModel?.toEntity()
    }
    
    var isLogin: Bool {
        accessTokenModel != nil && currentUserModel != nil
    }
    
    func login(accessToken: String, expiresDate: Date, user currentUserEntity: AuthUser) {
        self.accessTokenModel = AccessToken(token: accessToken, expiresDate: expiresDate)
        self.currentUserModel = AuthUserModel.from(entity: currentUserEntity)
        setToDeviceStore()
        
        log.debug("AuthManager login... token=\(String(describing: self.accessTokenModel)) currentUser=\(String(describing: self.currentUserModel))")
    }
    
    func logout() {
        log.debug("AuthManager logout...")
        reset()
    }
    
    private func reset() {
        log.debug("AuthManager reset...")
        accessTokenModel = nil
        currentUserModel = nil
        setToDeviceStore()
    }
    
    func validateToken() -> Bool {
        guard let expiresDate = accessTokenModel?.expiresDate else { return false }
        
        if Date() > expiresDate {
            log.warning("Token expired... currentDate=\(Date()) expiredDate=\(expiresDate)")
            reset()
            return false
        }
        
        return true
    }
    
    private func setToDeviceStore() {
        // MARK: save currentUserModel
        if let currentUserModel = currentUserModel {
            userDefaultHelper.save(value: currentUserModel, key: .authUser)
            log.debug("saved currentUserModel to UserDefaults... value=\(String(describing: currentUserModel))")
        } else {
            userDefaultHelper.delete(for: .authUser)
            log.debug("deleted currentUserModel from UserDefaults...")
        }
        
        // MARK: save accessTokenModel
        if let accessTokenModel = accessTokenModel {
            userDefaultHelper.save(value: accessTokenModel.expiresDate, key: .accessTokenExpiresAt)
            log.debug("saved accessTokenModel.expiresDate to UserDefaults... value=\(String(describing: accessTokenModel.expiresDate))")
            
            do {
                try keychainStore.saveValue(accessTokenModel.token, for: KeychainStore.ReservedAccount.AccessToken.rawValue)
                log.debug("saved accessTokenModel.token to keychain...")
            } catch {
                log.error("failed to save accessTokenModel.token to keychain... error: \(error)")
            }
        } else {
            userDefaultHelper.delete(for: .accessTokenExpiresAt)
            log.debug("deleted accessTokenModel.expiresDate from UserDefaults...")
            
            do {
                try keychainStore.remove(for: KeychainStore.ReservedAccount.AccessToken.rawValue)
                log.debug("deleted accessTokenModel.token from keychain...")
            } catch {
                log.error("failed to delete accessTokenModel.token from keychain... error: \(error)")
            }
        }
    }
    
    private func loadFromDeviceStore() {
        // MARK: load currentUserModel
        currentUserModel = userDefaultHelper.load(for: .authUser)
        log.debug("loaded currentUserModel from UserDefaults...")
        
        // MARK: load accessTokenModel
        var accessToken: String?
        do {
            try accessToken = keychainStore.loadValue(for: KeychainStore.ReservedAccount.AccessToken.rawValue)
        } catch {
            log.error("failed to load accessTokenModel.token from keychain... error: \(error)")
        }
        let expiresDate: Date? = userDefaultHelper.load(for: .accessTokenExpiresAt)
        
        guard let expiresDate = expiresDate,
              let accessToken = accessToken else { return }
        
        accessTokenModel = AccessToken(token: accessToken, expiresDate: expiresDate)
        log.debug("loaded accessTokenModel.token from keychain...")
    }
}
