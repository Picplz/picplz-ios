//
//  DataLayerAssembly.swift
//  PicplzClient
//
//  Created by 임영택 on 9/11/25.
//

import Foundation
import Swinject

/// 데이터 레이어 객체들을 등록한다.
final class DataLayerAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(AuthManaging.self) { _ in
            AuthManager(keychainStore: KeychainStore(), userDefaultHelper: UserDefaultsHelper())
        }
        .inObjectScope(.container)

        container.register(LocationService.self) { _ in
            LocationServiceImpl()
        }
        .inObjectScope(.container)

        container.register(AuthRequestable.self) { _ in
            AuthRequests()
        }

        container.register(CustomerRequestable.self) { _ in
            CustomerRequests()
        }
    }
}
