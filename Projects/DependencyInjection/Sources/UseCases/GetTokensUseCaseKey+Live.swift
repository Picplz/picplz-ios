//
//  GetTokensUseCaseKey+Live.swift
//  DependencyInjection
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Dependencies

extension GetTokensUseCaseKey: @retroactive DependencyKey {
  public static var liveValue: GetTokensUseCase {
    @Dependency(\.tokenStorage) var tokenStorage
    return .live(tokenStorage: tokenStorage)
  }
}
