//
//  CreateCustomerUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/2/26.
//

import Dependencies
import Foundation
import SwiftUI

public struct CreateCustomerUseCase {
  public var execute: (_ request: RegisterRequest) async throws -> Bool
}

public enum CreateCustomerUseCaseKey: DependencyKey {
  public static var liveValue: CreateCustomerUseCase {
    @Dependency(\.membersRepository) var membersRepository

    return CreateCustomerUseCase { request in
      try await membersRepository.createCustomer(request: request)
      return true
    }
  }
}

extension DependencyValues {
  public var createCustomerUseCase: CreateCustomerUseCase {
    get { self[CreateCustomerUseCaseKey.self] }
    set { self[CreateCustomerUseCaseKey.self] = newValue }
  }
}
