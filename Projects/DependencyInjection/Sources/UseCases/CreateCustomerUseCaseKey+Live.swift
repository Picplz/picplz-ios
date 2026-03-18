//
//  CreateCustomerUseCaseKey+Live.swift
//  DependencyInjection
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Dependencies

extension CreateCustomerUseCaseKey: @retroactive DependencyKey {
  public static var liveValue: CreateCustomerUseCase {
    @Dependency(\.membersRepository) var membersRepository
    return .live(membersRepository: membersRepository)
  }
}
