//
//  EquipmentRepositoryKey+Live.swift
//  DependencyInjection
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Networking
import Dependencies

extension EquipmentRepositoryKey: @retroactive DependencyKey {
  public static var liveValue: any EquipmentRepositoryProtocol {
    @Dependency(\.tokenStorage) var tokenStorage
    return EquipmentRepository(tokenStorage: tokenStorage)
  }
}
