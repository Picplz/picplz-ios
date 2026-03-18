//
//  GetDefaultPhotographEquipmentsUseCaseKey+Live.swift
//  DependencyInjection
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Dependencies

extension GetDefaultPhotographEquipmentsUseCaseKey: @retroactive DependencyKey {
  public static var liveValue: GetDefaultPhotographEquipmentsUseCase {
    @Dependency(\.equipmentRepository) var equipmentRepository
    return .live(equipmentRepository: equipmentRepository)
  }
}
