//
//  AuthManaging.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation

protocol AuthManaging {
    var accessToken: String? { get }
    var currentUser: AuthUser? { get }
    var isLogin: Bool { get }
    
    func login(accessToken: String, expiresDate: Date, user currentUserEntity: AuthUser)
    func logout()
}
