//
//  EquipmentRepositoryProtocol.swift
//  Domain
//
//  Created by 임영택 on 3/17/26.
//

import Dependencies
import Foundation

public protocol EquipmentRepositoryProtocol {
  func getDefaultEquipments() async throws -> [PhotographerEquipment]
}

struct UnimplementedEquipmentRepository: EquipmentRepositoryProtocol {
  func getDefaultEquipments() async throws -> [PhotographerEquipment] {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
}

public enum EquipmentRepositoryKey: DependencyKey {
  public static var liveValue: EquipmentRepositoryProtocol = UnimplementedEquipmentRepository()
}

public extension DependencyValues {
  var equipmentRepository: EquipmentRepositoryProtocol {
    get { self[EquipmentRepositoryKey.self] }
    set { self[EquipmentRepositoryKey.self] = newValue }
  }
}
