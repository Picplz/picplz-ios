//
//  UserDefaultsHelper.swift
//  PicplzClientTests
//
//  Created by 임영택 on 2/14/25.
//

import Testing
import Foundation
@testable import PicplzClient

extension UserDefaultsHelper.Key {
    static let testSaveString = UserDefaultsHelper.Key(rawValue: "testSaveString", expectedType: String.self)
    static let testSaveInt = UserDefaultsHelper.Key(rawValue: "testSaveInt", expectedType: Int.self)
    static let testSaveDouble = UserDefaultsHelper.Key(rawValue: "testSaveDouble", expectedType: Double.self)
    static let testSaveBool = UserDefaultsHelper.Key(rawValue: "testSaveBool", expectedType: Bool.self)
    static let testSaveStruct = UserDefaultsHelper.Key(rawValue: "testSaveStruct", expectedType: TestCustomStruct.self)
    static let testLoadString = UserDefaultsHelper.Key(rawValue: "testLoadString", expectedType: String.self)
    static let testLoadInt = UserDefaultsHelper.Key(rawValue: "testLoadInt", expectedType: Int.self)
    static let testLoadDouble = UserDefaultsHelper.Key(rawValue: "testLoadDouble", expectedType: Double.self)
    static let testLoadBool = UserDefaultsHelper.Key(rawValue: "testLoadBool", expectedType: Bool.self)
    static let testLoadStruct = UserDefaultsHelper.Key(rawValue: "testLoadStruct", expectedType: TestCustomStruct.self)
    static let testDelete = UserDefaultsHelper.Key(rawValue: "testDelete", expectedType: String.self)
}

struct TestCustomStruct: Codable, Equatable {
    let message: String
    let number: Int
    let yesOrNot: Bool
}

struct UserDefaultsHelperTest {
    let userDefaultsHelper: UserDefaultsHelper
    let userDefaultsInstance = UserDefaults.standard

    init() {
        userDefaultsHelper = UserDefaultsHelper()
    }

    @Test("문자열을 잘 저장해야한다")
    func saveString() async throws {
        let willSaveValue = "Hello, World"
        userDefaultsHelper.save(value: willSaveValue, key: .testSaveString)
        let savedValue = userDefaultsInstance.string(forKey: UserDefaultsHelper.Key.testSaveString.rawValue)

        #expect(savedValue == willSaveValue)
    }

    @Test("정수를 잘 저장해야한다")
    func saveInt() async throws {
        let willSaveValue = 200
        userDefaultsHelper.save(value: willSaveValue, key: .testSaveInt)
        let savedValue = userDefaultsInstance.integer(forKey: UserDefaultsHelper.Key.testSaveInt.rawValue)

        #expect(savedValue == willSaveValue)
    }

    @Test("실수를 잘 저장해야한다")
    func saveDouble() async throws {
        let willSaveValue = 123.45
        userDefaultsHelper.save(value: willSaveValue, key: .testSaveDouble)
        let savedValue = userDefaultsInstance.double(forKey: UserDefaultsHelper.Key.testSaveDouble.rawValue)

        #expect(savedValue == willSaveValue)
    }

    @Test("불리언을 잘 저장해야한다")
    func saveBool() async throws {
        let willSaveValue = true
        userDefaultsHelper.save(value: willSaveValue, key: .testSaveBool)
        let savedValue = userDefaultsInstance.bool(forKey: UserDefaultsHelper.Key.testSaveBool.rawValue)

        #expect(savedValue == willSaveValue)
    }

    @Test("커스텀 구조체를 잘 저장해야한다")
    func saveStruct() async throws {
        let willSaveValue = TestCustomStruct(message: "Hello World", number: 123, yesOrNot: false)
        userDefaultsHelper.save(value: willSaveValue, key: .testSaveStruct)

        let savedValue = userDefaultsInstance.data(forKey: UserDefaultsHelper.Key.testSaveStruct.rawValue)!
        print(String(decoding: savedValue, as: UTF8.self))

        let decoder = JSONDecoder()
        let savedObject = try decoder.decode(TestCustomStruct.self, from: savedValue)

        #expect(willSaveValue == savedObject)
    }

    @Test("문자열을 잘 불러와야 한다")
    func loadString() async throws {
        let willSaveValue = "Hello, World"
        userDefaultsInstance.set(willSaveValue, forKey: UserDefaultsHelper.Key.testLoadString.rawValue)

        let savedValue: String? = userDefaultsHelper.load(for: .testLoadString)

        #expect(savedValue == willSaveValue)
    }

    @Test("정수를 잘 불러와야 한다")
    func loadInt() async throws {
        let willSaveValue = 300
        userDefaultsInstance.set(willSaveValue, forKey: UserDefaultsHelper.Key.testLoadInt.rawValue)

        let savedValue: Int? = userDefaultsHelper.load(for: .testLoadInt)

        #expect(savedValue == willSaveValue)
    }

    @Test("실수를 잘 불러와야 한다")
    func loadDouble() async throws {
        let willSaveValue = 678.91
        userDefaultsInstance.set(willSaveValue, forKey: UserDefaultsHelper.Key.testLoadDouble.rawValue)

        let savedValue: Double? = userDefaultsHelper.load(for: .testLoadDouble)

        #expect(savedValue == willSaveValue)
    }

    @Test("불리언을 잘 불러와야 한다")
    func loadBool() async throws {
        let willSaveValue = true
        userDefaultsInstance.set(willSaveValue, forKey: UserDefaultsHelper.Key.testLoadBool.rawValue)

        let savedValue: Bool? = userDefaultsHelper.load(for: .testLoadBool)

        #expect(savedValue == willSaveValue)
    }

    @Test("커스텀 구조체를 잘 불러와야 한다")
    func loadStruct() async throws {
        let willSaveValue = TestCustomStruct(message: "Bye World", number: 456, yesOrNot: true)
        let encoder = JSONEncoder()
        let willSaveJsonData = try encoder.encode(willSaveValue)
        userDefaultsInstance.set(willSaveJsonData, forKey: UserDefaultsHelper.Key.testLoadStruct.rawValue)

        let savedObject: TestCustomStruct? = userDefaultsHelper.load(for: .testLoadStruct)

        #expect(willSaveValue == savedObject)
    }

    @Test("아이템을 잘 삭제해야 한다")
    func deleteItem() async throws {
        let willSaveValue = "Hello, World"
        userDefaultsInstance.set(willSaveValue, forKey: UserDefaultsHelper.Key.testDelete.rawValue)

        userDefaultsHelper.delete(for: UserDefaultsHelper.Key.testDelete)

        let loaded = userDefaultsInstance.string(forKey: UserDefaultsHelper.Key.testDelete.rawValue)
        #expect(loaded == nil)
    }
}
