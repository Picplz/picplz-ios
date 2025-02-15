//
//  UserDefaultsHelper.swift
//  PicplzClient
//
//  Created by 임영택 on 2/14/25.
//

import Foundation
import OSLog

final class UserDefaultsHelper {
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let log = Logger.of("UserDefaultsHelper")
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }
    
    convenience init() {
        self.init(userDefaults: UserDefaults.standard)
    }
    
    private func saveCustomObject<T: Encodable>(_ object: T, key: Key) {
        do {
            let jsonData = try encoder.encode(object)
            userDefaults.set(jsonData, forKey: key.rawValue)
        } catch {
            log.error("Encode data failed... key: \(key.rawValue) value: \(String(describing: object)) error: \(error)")
        }
    }
    
    private func loadCustomData<T: Decodable>(for key: Key, as type: T.Type) -> T? {
        guard let jsonData = userDefaults.data(forKey: key.rawValue) else {
            log.error("No data from UserDefaults... key: \(key.rawValue)")
            return nil
        }
        
        do {
            let object = try decoder.decode(T.self, from: jsonData)
            return object
        } catch {
            log.error("Decode data failed... key: \(key.rawValue) error: \(error)")
            return nil
        }
    }
    
    func save(value: Any, key: Key) {
        let keyRaw = key.rawValue
        let expectedType = key.expectedType
        
        switch expectedType {
        case is String.Type:
            fallthrough
        case is Int.Type:
            fallthrough
        case is Double.Type:
            fallthrough
        case is Bool.Type:
            fallthrough
        case is Data.Type:
            userDefaults.set(value, forKey: key.rawValue)
        case is Codable.Type:
            if let value = value as? Codable {
                saveCustomObject(value, key: key)
            }
        default:
            userDefaults.set(value, forKey: keyRaw)
        }
    }
    
    func load<T>(for key: Key) -> T? {
        let expectedType = key.expectedType
        
        switch expectedType {
        case is String.Type:
            log.info("String")
            return userDefaults.string(forKey: key.rawValue) as? T
        case is Int.Type:
            return userDefaults.integer(forKey: key.rawValue) as? T
        case is Double.Type:
            return userDefaults.double(forKey: key.rawValue) as? T
        case is Bool.Type:
            return userDefaults.bool(forKey: key.rawValue) as? T
        case is Data.Type:
            return userDefaults.data(forKey: key.rawValue) as? T
        case is Codable.Type:
            if let expectedType = expectedType as? Decodable.Type {
                return loadCustomData(for: key, as: expectedType) as? T
            }
        default:
            log.error("Unsupported type \(expectedType) for key \(key.rawValue)")
            return nil
        }
        
        return nil
    }
    
    func delete(for key: Key) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
    struct Key: RawRepresentable {
        let rawValue: String
        let expectedType: Any.Type
        
        init?(rawValue: String) {
            self.rawValue = rawValue
            self.expectedType = Any.self
        }
        
        init(rawValue: String, expectedType: Any.Type) {
            self.rawValue = rawValue
            self.expectedType = expectedType
        }
        
        static let accessTokenExpiresAt = Key(rawValue: "accessTokenExpiresAt", expectedType: Date.self)
        static let authUser = Key(rawValue: "authUser", expectedType: AuthUserModel.self)
    }
}
