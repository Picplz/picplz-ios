//
//  UseCasesAssembly.swift
//  PicplzClient
//
//  Created by 임영택 on 9/12/25.
//

import Foundation
import Swinject

/// 유즈케이스 객체들을 등록한다.
final class UseCasesAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(LoginUseCase.self) { resolver in
            let authManaging = resolver.resolve(AuthManaging.self)!
            let authReqeusts = resolver.resolve(AuthRequestable.self)!
            return LoginUseCaseImpl(authManaging: authManaging, authRequests: authReqeusts)
        }
        container.register(LogoutUseCase.self) { resolver in
            let authManaging = resolver.resolve(AuthManaging.self)!
            return LogoutUseCaseImpl(authManaging: authManaging)
        }
        container.register(GetAuthInfoUseCase.self) { resolver in
            let authManaging = resolver.resolve(AuthManaging.self)!
            return GetAuthInfoUseCaseImpl(authManaging: authManaging)
        }
        container.register(SendSignUpRequestUseCase.self) { resolver in
            let authManaging = resolver.resolve(AuthManaging.self)!
            let customerRequestable = resolver.resolve(CustomerRequestable.self)!
            return SendSignUpRequestUseCaseImpl(authManaging: authManaging, customerRequests: customerRequestable)
        }
        container.register(GetShortAddressUseCase.self) { resolver in
            let locationService = resolver.resolve(LocationService.self)!
            return GetShortAddressUserCaseImpl(locationService: locationService)
        }
    }
}
