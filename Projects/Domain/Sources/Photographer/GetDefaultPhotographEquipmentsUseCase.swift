//
//  GetDefaultPhotographEquipmentsUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/17/26.
//

import Dependencies
import Foundation

public protocol GetDefaultPhotographEquipmentsUseCaseProtocol {
  func execute() async throws -> [PhotographerEquipment]
}

public struct GetDefaultPhotographEquipmentsUseCase: GetDefaultPhotographEquipmentsUseCaseProtocol {
  @Dependency(\.equipmentRepository) var equipmentRepository
  
  public init() {}
  
  public func execute() async throws -> [PhotographerEquipment] {
    return try await equipmentRepository.getDefaultEquipments()
  }
}

public enum GetDefaultPhotographEquipmentsUseCaseKey: DependencyKey {
  public static var liveValue: GetDefaultPhotographEquipmentsUseCaseProtocol = GetDefaultPhotographEquipmentsUseCase()
}

public extension DependencyValues {
  var getDefaultPhotographEquipmentsUseCase: GetDefaultPhotographEquipmentsUseCaseProtocol {
    get { self[GetDefaultPhotographEquipmentsUseCaseKey.self] }
    set { self[GetDefaultPhotographEquipmentsUseCaseKey.self] = newValue }
  }
}
