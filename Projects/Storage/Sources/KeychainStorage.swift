//
//  KeychainStorage.swift
//  Storage
//
//  Created by 임영택 on 2/28/26.
//

import Foundation
import Domain
import Security

public final class KeychainStorage: TokenStorageProtocol {
  private let service = "com.hm.picplz"
  private let accessTokenAccount = "picplz.access_token"
  private let refreshTokenAccount = "picplz.refresh_token"
  
  public init() {}
  
  public func saveAccessToken(_ token: PicplzAuthToken) throws {
    try save(token: token, account: accessTokenAccount)
  }
  
  public func saveRefreshToken(_ token: PicplzAuthToken) throws {
    try save(token: token, account: refreshTokenAccount)
  }
  
  public func getAccessToken() -> PicplzAuthToken? {
    return get(account: accessTokenAccount)
  }
  
  public func getRefreshToken() -> PicplzAuthToken? {
    return get(account: refreshTokenAccount)
  }
  
  public func deleteTokens() throws {
    try delete(account: accessTokenAccount)
    try delete(account: refreshTokenAccount)
  }
  
  private func save(token: PicplzAuthToken, account: String) throws {
    guard let data = token.data(using: .utf8) else { return }
    
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecValueData: data
    ]
    
    // Check if it already exists
    let status = SecItemAdd(query as CFDictionary, nil)
    
    if status == errSecDuplicateItem {
      // Update existing item
      let updateQuery: [CFString: Any] = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account
      ]
      
      let attributes: [CFString: Any] = [
        kSecValueData: data
      ]
      
      let updateStatus = SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
      if updateStatus != errSecSuccess {
        throw KeychainError.saveFailed(updateStatus)
      }
    } else if status != errSecSuccess {
      throw KeychainError.saveFailed(status)
    }
  }
  
  private func get(account: String) -> PicplzAuthToken? {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecReturnData: true,
      kSecMatchLimit: kSecMatchLimitOne
    ]
    
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    
    if status == errSecSuccess, let data = result as? Data, let token = String(data: data, encoding: .utf8) {
      return token
    }
    
    return nil
  }
  
  private func delete(account: String) throws {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: account
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    if status != errSecSuccess && status != errSecItemNotFound {
      throw KeychainError.deleteFailed(status)
    }
  }
}

public enum KeychainError: LocalizedError {
  case saveFailed(OSStatus)
  case deleteFailed(OSStatus)
  
  public var errorDescription: String? {
    switch self {
    case .saveFailed(let status):
      return "Keychain 저장에 실패했습니다. (Status: \(status))"
    case .deleteFailed(let status):
      return "Keychain 삭제에 실패했습니다. (Status: \(status))"
    }
  }
}
