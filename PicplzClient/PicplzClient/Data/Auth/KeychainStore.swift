//
//  KeychainStore.swift
//  PicplzClient
//
//  Created by 임영택 on 2/14/25.
//

import Foundation
import Security
import OSLog

final class KeychainStore {
    let queryBase: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: Bundle.main.bundleIdentifier ?? "com.hm.picplz.PicplzClient"
    ]

    private let log = Logger.of("KeyChainStore")

    func saveValue(_ value: String, for account: String) throws {
        guard let valueAsData = value.data(using: .utf8) else {
            log.error("failed to encode string to data")
            throw KeyChainStoreError.failedToEncodeToData
        }

        var query = queryBase
        query[String(kSecAttrAccount)] = account

        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            let shouldUpdateAttributes: [String: Any] = [
                kSecValueData as String: valueAsData
            ]

            status = SecItemUpdate(query as CFDictionary, shouldUpdateAttributes as CFDictionary)
            if status != errSecSuccess {
                throw getError(from: status)
            }
        case errSecItemNotFound:
            query[String(kSecValueData)] = valueAsData

            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw getError(from: status)
            }
        default:
            throw getError(from: status)
        }
    }

    func loadValue(for account: String) throws -> String? {
        var query = queryBase
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = account

        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
          SecItemCopyMatching(query as CFDictionary, $0)
        }

        switch status {
        case errSecSuccess:
            if let result = result as? [String: Any],
               let loadedValue = result[String(kSecValueData)] as? Data,
               let decodedValue = String(data: loadedValue, encoding: .utf8) {
                return decodedValue
            } else {
                throw KeyChainStoreError.failedToDecodeToString
            }
        case errSecItemNotFound:
            return nil
        default:
            throw getError(from: status)
        }
    }

    func remove(for account: String) throws {
        var query = queryBase
        query[String(kSecAttrAccount)] = account

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw getError(from: status)
        }
    }

    func removeAll() throws {
        let query = queryBase

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw getError(from: status)
        }
    }

    private func getError(from status: OSStatus) -> KeyChainStoreError {
        let message = SecCopyErrorMessageString(status, nil) as String? ?? "Unexpected..."
        return KeyChainStoreError.unknown(message)
    }

    enum ReservedAccount: String {
        case accessToken
        case refreshToken
    }

    enum KeyChainStoreError: Error {
        case failedToEncodeToData
        case failedToDecodeToString
        case unknown(String)
    }
}
