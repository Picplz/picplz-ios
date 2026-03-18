//
//  MembersRepositoryKey+Live.swift
//  DependencyInjection
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Networking
import Dependencies

extension MembersRepositoryKey: @retroactive DependencyKey {
  public static var liveValue: any MembersRepositoryProtocol {
    @Dependency(\.tokenStorage) var tokenStorage
    return MembersRepository(tokenStorage: tokenStorage)
  }
}
