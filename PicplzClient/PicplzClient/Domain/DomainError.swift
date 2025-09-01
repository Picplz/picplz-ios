//
//  DomainError.swift
//  PicplzClient
//
//  Created by 임영택 on 4/5/25.
//

import Foundation

enum DomainError: LocalizedError {
    // MARK: - Common
    case validationError(String)
    case serverError(String)
    
    // MARK: - Auth
    case notRegisteredUser
    case venderError(String)
    
    public var errorDescription: String? {
        switch self {
        case .validationError(let message):
            return "값 검증에 실패했습니다. \(message)"
        case .serverError(let message):
            return "문제가 발생했습니다. \(message)"
        case .notRegisteredUser:
            return "등록되지 않은 유저여서 로그인할 수 없습니다."
        case .venderError(let message):
            return "연계 서비스 에러입니다. \(message)"
        }
    }
}
