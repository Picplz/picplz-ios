//
//  DomainError.swift
//  PicplzClient
//
//  Created by 임영택 on 4/5/25.
//

import Foundation

enum DomainError: LocalizedError {
    case validationError(String)
    case internalError(String)
    
    public var errorDescription: String? {
        switch self {
        case .validationError(let message):
            return "값 검증에 실패했습니다. \(message)"
        case .internalError(let message):
            return "문제가 발생했습니다. \(message)"
        }
    }
}
