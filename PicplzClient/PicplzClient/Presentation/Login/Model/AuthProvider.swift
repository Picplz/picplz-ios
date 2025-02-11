//
//  AuthProvider.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation

enum AuthProvider {
    case kakao
    case apple
    
    func getAuthEntrypointPath() -> String {
        switch self {
        case .kakao:
            "/oauth2/authorization/kakao"
        case .apple:
            "" // TODO: add url
        }
    }
}
