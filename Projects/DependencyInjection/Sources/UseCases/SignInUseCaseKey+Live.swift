//
//  SignInUseCaseKey+Live.swift
//  DependencyInjection
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Dependencies

extension SignInUseCaseKey: @retroactive DependencyKey {
  public static var liveValue: SignInUseCase {
    @Dependency(\.authRepository) var authRepository
    @Dependency(\.tokenStorage) var tokenStorage
    return .live(authRepository: authRepository, tokenStorage: tokenStorage)
  }
}
