//
//  AuthManager.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation
import OSLog

final class AuthManager: AuthManaging {    
    private var accessTokenModel: AccessToken?
    private var currentUserModel: AuthUserModel?
    private var log = Logger.of("AuthManager")
    
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
        
        log.info("AuthManager login... token=\(String(describing: self.accessTokenModel)) currentUser=\(String(describing: self.currentUserModel))")
    }
    
    func logout() {
        log.info("AuthManager logout...")
        reset()
    }
    
    private func reset() {
        log.info("AuthManager reset...")
        accessTokenModel = nil
        currentUserModel = nil
    }
    
    func validateToken() -> Bool {
        guard let expiresDate = accessTokenModel?.expiresDate else { return false }
        
        if Date() > expiresDate {
            log.info("Token expired... currentDate=\(Date()) expiredDate=\(expiresDate)")
            reset()
            return false
        }
        
        return true
    }
}
