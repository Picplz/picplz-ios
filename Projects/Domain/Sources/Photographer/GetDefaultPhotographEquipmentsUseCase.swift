//
//  GetDefaultPhotographEquipmentsUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/17/26.
//

import Dependencies
import Foundation

public struct GetDefaultPhotographEquipmentsUseCase {
  public var execute: () async throws -> [PhotographerEquipment]

  public static func live(equipmentRepository: any EquipmentRepositoryProtocol) -> Self {
    Self {
      try await equipmentRepository.getDefaultEquipments()
    }
  }

  public static var test: Self {
    Self { [] }
  }
}

public enum GetDefaultPhotographEquipmentsUseCaseKey: TestDependencyKey {
  public static var testValue: GetDefaultPhotographEquipmentsUseCase = .test
}

public extension DependencyValues {
  var getDefaultPhotographEquipmentsUseCase: GetDefaultPhotographEquipmentsUseCase {
    get { self[GetDefaultPhotographEquipmentsUseCaseKey.self] }
    set { self[GetDefaultPhotographEquipmentsUseCaseKey.self] = newValue }
  }
}
