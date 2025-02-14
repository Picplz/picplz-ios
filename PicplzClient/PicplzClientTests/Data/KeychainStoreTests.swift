//
//  KeychainStoreTests.swift
//  PicplzClientTests
//
//  Created by 임영택 on 2/14/25.
//

import Testing
import Foundation
import Security
@testable import PicplzClient

struct KeychainStoreTests {
    let store: KeychainStore
    
    init() {
        store = KeychainStore()
    }
    
    let accountForTest = "accountForTest-" + UUID().uuidString
    let secretForTest = "secret#1234@"
    
    @Test("아이템 저장에 성공해야 한다.")
    func addNewItem() async throws {
        try store.saveValue(secretForTest, for: accountForTest)
        
        var query = store.queryBase
        query[String(kSecAttrAccount)] = accountForTest
        
        // MARK: Validate
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
          SecItemCopyMatching(query as CFDictionary, $0)
        }
        
        if status != errSecSuccess {
            throw NSError(domain: "조회 에러", code: 0)
        }
        
        guard let result = result as? [String: Any],
              let data = result[String(kSecValueData)] as? Data,
              let decoded = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "디코딩 에러", code: 0)
        }
        
        #expect(decoded == secretForTest)
    }
    
    @Test("아이템 수정에 성공해야 한다.")
    func updateItem() async throws {
        try store.saveValue(secretForTest, for: accountForTest)
        try store.saveValue(secretForTest + "%%updated!!", for: accountForTest) // try twice
        
        var query = store.queryBase
        query[String(kSecAttrAccount)] = accountForTest
        
        // MARK: Validate
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
          SecItemCopyMatching(query as CFDictionary, $0)
        }
        
        if status != errSecSuccess {
            throw NSError(domain: "조회 에러", code: 0)
        }
        
        guard let result = result as? [String: Any],
              let data = result[String(kSecValueData)] as? Data,
              let decoded = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "디코딩 에러", code: 0)
        }
        
        #expect(decoded == secretForTest + "%%updated!!")
    }
    
    @Test("아이템 삭제에 성공해야 한다.")
    func deleteItem() async throws {
        // MARK: Set Test Pre Condition
        guard let data = secretForTest.data(using: .utf8) else {
            throw NSError(domain: "인코딩 실패", code: 0)
        }
        var query = store.queryBase
        query[String(kSecAttrAccount)] = accountForTest
        query[String(kSecValueData)] = data
        
        var status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw NSError(domain: "저장 실패", code: 0)
        }
        
        // MARK: Do Test
        try store.remove(for: accountForTest)
        
        // MARK: Validate
        var queryForValidate = store.queryBase
        queryForValidate[String(kSecAttrAccount)] = accountForTest
        status = SecItemCopyMatching(query as CFDictionary, nil)
        
        #expect(status == errSecItemNotFound)
    }
    
    @Test("모든 아이템 삭제에 성공해야 한다.")
    func deleteAllItem() async throws {
        // MARK: Set Test Pre Condition
        let secrets = [1, 2, 3, 4, 5].map({ number in
            return secretForTest + String(number)
        })
        .map { $0.data(using: .utf8) }
        .compactMap { $0 }
        
        if secrets.count != 5 {
            throw NSError(domain: "인코딩 실패", code: 0)
        }
        
        try secrets.forEach {
            var query = store.queryBase
            query[String(kSecAttrAccount)] = accountForTest + UUID().uuidString
            query[String(kSecValueData)] = $0
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw NSError(domain: "저장 실패", code: 0)
            }
        }
        
        // MARK: Do Test
        try store.removeAll()
        
        // MARK: Validate
        var queryForValidate = store.queryBase
        queryForValidate[String(kSecMatchLimit)] = kSecMatchLimitAll
        queryForValidate[String(kSecReturnData)] = kCFBooleanTrue
        queryForValidate[String(kSecReturnAttributes)] = kCFBooleanTrue
        
        let status = SecItemCopyMatching(queryForValidate as CFDictionary, nil)
        #expect(status == errSecItemNotFound)
    }
}
